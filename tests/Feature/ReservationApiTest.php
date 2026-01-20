<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\Reservation;
use App\Models\Restaurant;
use App\Models\Table;

class ReservationApiTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test the reservations index endpoint.
     */
    public function test_reservations_index(): void
    {
        $response = $this->getJson('/api/reservations');

        $response->assertStatus(200);
    }

    /**
     * Test creating a reservation.
     */
    public function test_create_reservation(): void
    {
        $restaurant = Restaurant::factory()->create();
        $table = Table::factory()->create(['restaurant_id' => $restaurant->id]);

        $data = [
            'restaurant_id' => $restaurant->id,
            'table_id' => $table->id,
            'customer_name' => 'John Doe',
            'customer_email' => 'john@example.com',
            'customer_phone' => '1234567890',
            'party_size' => 4,
            'date' => now()->addDay()->format('Y-m-d'),
            'start_time' => '18:00',
            'end_time' => '20:00',
            'status' => 'pending',
            'reservation_type' => 'dinner',
        ];

        $response = $this->postJson('/api/reservations', $data);

        $response->assertStatus(201);
        $this->assertDatabaseHas('reservations', $data);
    }

    /**
     * Test check availability endpoint.
     */
    public function test_check_availability(): void
    {
        $restaurant = Restaurant::factory()->create();
        Table::factory()->create(['restaurant_id' => $restaurant->id, 'is_active' => true]);

        $data = [
            'restaurant_id' => $restaurant->id,
            'date' => now()->addDay()->format('Y-m-d'),
            'start_time' => '18:00',
            'end_time' => '20:00',
        ];

        $response = $this->postJson('/api/reservations/check-availability', $data);

        $response->assertStatus(200);
        $response->assertJsonStructure(['available', 'tables', 'count']);
    }
}
