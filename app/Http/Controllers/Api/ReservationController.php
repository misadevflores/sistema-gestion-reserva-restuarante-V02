<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Reservation;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class ReservationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $reservations = Reservation::with(['restaurant', 'table'])->get();
        return response()->json($reservations);
    }

    /**
     * Check table availability for a given date and time.
     */
    public function checkAvailability(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'restaurant_id' => 'required|exists:restaurants,id',
            'date' => 'required|date|after_or_equal:today',
            'start_time' => 'required|date_format:H:i',
            'end_time' => 'date_format:H:i|after:start_time',
            'party_size' => 'sometimes|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $restaurant = \App\Models\Restaurant::find($request->restaurant_id);
        $tables = $restaurant->tables()->where('is_active', true)->get();

        $availableTables = [];
        foreach ($tables as $table) {
            if (!$table->hasConflictingReservation($request->date, $request->start_time, $request->end_time)) {
                if (isset($request->party_size) && $table->capacity < $request->party_size) {
                    continue; // Skip if party size exceeds table capacity
                }
                $availableTables[] = $table;
            }
        }

        return response()->json([
            'available' => count($availableTables) > 0,
            'tables' => $availableTables,
            'count' => count($availableTables)
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'restaurant_id' => 'required|exists:restaurants,id',
            'table_id' => 'required|exists:tables,id',
            'customer_name' => 'required|string|max:255',
            'customer_email' => 'email|max:255',
            'customer_phone' => 'required|string|max:20',
            'party_size' => 'required|integer|min:1',
            'date' => 'required|date|after_or_equal:today',
            'start_time' => 'required|date_format:H:i',
            'end_time' => 'date_format:H:i|after:start_time',
            'duration' => 'integer|min:1',
            'status' => 'required|in:pending,confirmed,cancelled',
            'notes' => 'nullable|string',
            'reservation_type' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Check for table availability
        $table = \App\Models\Table::find($request->table_id);
        if ($table->hasConflictingReservation($request->date, $request->start_time, $request->end_time)) {
            return response()->json(['error' => 'Table is not available at the requested time'], 409);
        }

        $reservation = Reservation::create($request->all());
        return response()->json($reservation, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Reservation $reservation): JsonResponse
    {
        return response()->json($reservation->load(['restaurant', 'table']));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Reservation $reservation): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'restaurant_id' => 'sometimes|exists:restaurants,id',
            'table_id' => 'sometimes|exists:tables,id',
            'customer_name' => 'sometimes|string|max:255',
            'customer_email' => 'email|max:255',
            'customer_phone' => 'sometimes|string|max:20',
            'party_size' => 'sometimes|integer|min:1',
            'date' => 'sometimes|date|after_or_equal:today',
            'start_time' => 'sometimes|date_format:H:i',
            'end_time' => 'date_format:H:i|after:start_time',
            'duration' => 'integer|min:1',
            'status' => 'sometimes|in:pending,confirmed,cancelled',
            'notes' => 'nullable|string',
            'reservation_type' => 'sometimes|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $reservation->update($request->all());
        return response()->json($reservation);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Reservation $reservation): JsonResponse
    {
        $reservation->delete();
        return response()->json(['message' => 'Reservation deleted successfully']);
    }
}
