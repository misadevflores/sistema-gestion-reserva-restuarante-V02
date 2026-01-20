<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Table extends Model
{
    use HasFactory;

    protected $fillable = [
        'restaurant_id',
        'name',
        'capacity',
        'min_capacity',
        'location',
        'status',
        'is_active',
    ];

    // Relaciones
    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class);
    }

    public function restaurantArea()
    {
        return $this->belongsTo(RestaurantArea::class, 'restaurant_area_id');
    }

    public function reservations()
    {
        return $this->belongsToMany(Reservation::class, 'reservation_tables');
    }

    // Método útil: ¿tiene conflicto en este horario?
    public function hasConflictingReservation(string $date, string $startTime, string $endTime): bool
    {
        return $this->reservations()
            ->where('date', $date)
            ->where('status', '!=', 'cancelled')
            ->where(function ($query) use ($startTime, $endTime) {
                $query->whereBetween('start_time', [$startTime, $endTime])
                      ->orWhereBetween('end_time', [$startTime, $endTime])
                      ->orWhere(function ($q) use ($startTime, $endTime) {
                          $q->where('start_time', '<=', $startTime)
                            ->where('end_time', '>=', $endTime);
                      });
            })->exists();
    }
}