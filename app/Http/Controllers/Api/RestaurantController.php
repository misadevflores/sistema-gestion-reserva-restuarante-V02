<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Restaurant;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class RestaurantController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $restaurants = Restaurant::with(['user', 'tables', 'reservations', 'menus', 'promotions', 'restaurantAreas', 'areaTables', 'reservationTables'])->get();
        return response()->json($restaurants);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'name' => 'required|string|max:255',
            'slug' => 'required|string|max:255|unique:restaurants,slug',
            'description' => 'nullable|string',
            'address' => 'required|string|max:255',
            'city' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'open_time' => 'required|date_format:H:i',
            'close_time' => 'required|date_format:H:i|after:open_time',
            'default_reservation_duration' => 'nullable|integer|min:1',
            'cleanup_buffer_minutes' => 'nullable|integer|min:0',
            'accepts_walk_ins' => 'boolean',
            'is_active' => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $restaurant = Restaurant::create($request->all());
        return response()->json($restaurant->load(['user', 'tables', 'reservations', 'menus', 'promotions', 'restaurantAreas', 'areaTables', 'reservationTables']), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Restaurant $restaurant): JsonResponse
    {
        return response()->json($restaurant->load(['user', 'tables', 'reservations', 'menus', 'promotions', 'restaurantAreas', 'areaTables', 'reservationTables']));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Restaurant $restaurant): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'sometimes|exists:users,id',
            'name' => 'sometimes|string|max:255',
            'slug' => 'sometimes|string|max:255|unique:restaurants,slug,' . $restaurant->id,
            'description' => 'nullable|string',
            'address' => 'sometimes|string|max:255',
            'city' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'open_time' => 'sometimes|date_format:H:i',
            'close_time' => 'sometimes|date_format:H:i|after:open_time',
            'default_reservation_duration' => 'nullable|integer|min:1',
            'cleanup_buffer_minutes' => 'nullable|integer|min:0',
            'accepts_walk_ins' => 'boolean',
            'is_active' => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $restaurant->update($request->all());
        return response()->json($restaurant->load(['user', 'tables', 'reservations', 'menus', 'promotions']));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Restaurant $restaurant): JsonResponse
    {
        $restaurant->delete();
        return response()->json(['message' => 'Restaurant deleted successfully']);
    }
}
