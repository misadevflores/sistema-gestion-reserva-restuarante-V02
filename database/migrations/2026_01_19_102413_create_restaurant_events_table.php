<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('restaurant_events', function (Blueprint $table) {
            $table->id(); // equivale a: bigint UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY

            $table->unsignedBigInteger('id_type');        // id del tipo de evento
            $table->unsignedBigInteger('restaurant_id');  // id del restaurante
            $table->boolean('status')->default(true);     // tinyint(1) DEFAULT 1

            $table->timestamps(); // created_at + updated_at

            // Clave foránea
            $table->foreign('restaurant_id')
                  ->references('id')
                  ->on('restaurants')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('restaurant_events');
    }
};