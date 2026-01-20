<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Restaurant extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'slug',
        'description',
        'address',
        'city',
        'phone',
        'email',
        'open_time',
        'close_time',
        'default_reservation_duration',
        'cleanup_buffer_minutes',
        'accepts_walk_ins',
        'is_active',
    ];

    // Relaciones
    public function user()
    {
        return $this->belongsTo(\App\Models\User::class)->withDefault();
    }

    public function tables()
    {
        return $this->hasMany(Table::class);
    }

    public function reservations()
    {
        return $this->hasMany(Reservation::class);
    }

    public function menus()
    {
        return $this->hasMany(\App\Models\Menu\Menu::class);
    }

    public function promotions()
    {
        return $this->hasMany(\App\Models\Promotion::class);
    }

    public function restaurantAreas()
    {
        return $this->hasMany(\App\Models\RestaurantArea::class);
    }

    public function restaurantEvents()
    {
        return $this->hasMany(\App\Models\RestaurantEvent::class);
    }

    public function typeEvents()
    {
        return $this->hasMany(\App\Models\TypeEvent::class);
    }

    public function areaTables()
    {
        return $this->hasManyThrough(\App\Models\Table::class, \App\Models\RestaurantArea::class, 'restaurant_id', 'id', 'id', 'table_id');
    }

    public function reservationTables()
    {
        return $this->hasManyThrough(\App\Models\Table::class, \App\Models\ReservationTable::class, 'restaurant_id', 'id', 'id', 'table_id');
    }
}