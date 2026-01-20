<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\Restaurant;
use App\Models\User;

class RestaurantApiTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test the restaurants index endpoint.
     */
    public function test_restaurants_index(): void
    {
        $response = $this->getJson('/api/restaurants');

        $response->assertStatus(200);
    }

    /**
     * Test creating a restaurant.
     */
    public function test_create_restaurant(): void
    {
        $user = User::factory()->create();

        $data = [
            'user_id' => $user->id,
            'name' => 'Test Restaurant',
            'slug' => 'test-restaurant',
            'description' => 'A test restaurant',
            'address' => '123 Test St',
            'city' => 'Test City',
            'phone' => '1234567890',
            'email' => 'test@example.com',
            'open_time' => '09:00',
            'close_time' => '22:00',
            'is_active' => true,
        ];

        $response = $this->postJson('/api/restaurants', $data);

        $response->assertStatus(201);
        $this->assertDatabaseHas('restaurants', $data);
    }

    /**
     * Test showing a restaurant with relationships.
     */
    public function test_show_restaurant_with_relationships(): void
    {
        $user = User::factory()->create();
        $restaurant = Restaurant::factory()->create(['user_id' => $user->id]);

        $response = $this->getJson('/api/restaurants/' . $restaurant->id);

        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'id',
                     'name',
                     'user' => ['id', 'name'],
                     'tables' => [],
                     'reservations' => [],
                     'menus' => [],
                     'promotions' => []
                 ]);
    }
}
