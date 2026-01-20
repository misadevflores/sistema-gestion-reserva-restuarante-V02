<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RestaurantEvent extends Model
{
    use HasFactory;

    protected $table = 'restaurant_event';

    protected $fillable = [
        'id_type',
        'restaurant_id',
        'status',
    ];

    // Relaciones
    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class);
    }

    public function typeEvent()
    {
        return $this->belongsTo(TypeEvent::class, 'id_type');
    }
}
