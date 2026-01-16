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
        return $this->belongsTo(\App\Models\User::class);
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
        // return $this->hasMany(Menu::class);
    }

    public function promotions()
    {
        // return $this->hasMany(Promotion::class);
    }
}