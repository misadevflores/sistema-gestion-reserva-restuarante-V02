<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ReservationController;
use App\Http\Controllers\Api\RestaurantController;


Route::apiResource('reservations', ReservationController::class);
Route::post('reservations/check-availability', [ReservationController::class, 'checkAvailability']);

Route::apiResource('restaurants', RestaurantController::class);
