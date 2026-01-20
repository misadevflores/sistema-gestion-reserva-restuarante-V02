<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TypeEvent extends Model
{
    use HasFactory;

    protected $table = 'type_events';

    protected $fillable = [
        'name',
        'description',
        'status',
    ];

    // Relaciones
    public function restaurantEvents()
    {
        return $this->hasMany(RestaurantEvent::class, 'id_type');
    }
}
