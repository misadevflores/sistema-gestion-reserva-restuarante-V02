<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reservation extends Model
{
    use HasFactory;

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($reservation) {
            if (empty($reservation->codigo)) {
                $reservation->codigo = 'RES-' . strtoupper(uniqid());
            }
        });
    }

    protected $fillable = [
        'restaurant_id',
        'codigo',
        'customer_name',
        'customer_email',
        'customer_phone',
        'party_size',
        'date',
        'start_time',
        'end_time',
        'duration',
        'status',
        'notes',
        'source',
        'reservation_type',
    ];

    protected $casts = [
        'date' => 'date',
    ];

    // Relaciones
    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class);
    }

    public function tables()
    {
        return $this->belongsToMany(Table::class, 'reservation_tables');
    }

    // Scopes útiles
    public function scopeConfirmed($query)
    {
        return $query->where('status', 'confirmed');
    }

    public function scopeToday($query)
    {
        return $query->where('date', today());
    }

    public function scopeByType($query, string $type)
    {
        return $query->where('reservation_type', $type);
    }
}