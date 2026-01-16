<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ReservationController;


Route::apiResource('reservations', ReservationController::class);
Route::post('reservations/check-availability', [ReservationController::class, 'checkAvailability']);