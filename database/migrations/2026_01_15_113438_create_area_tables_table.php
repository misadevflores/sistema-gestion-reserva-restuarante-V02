<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('area_tables', function (Blueprint $table) {
            $table->bigIncrements('id_area_table'); // ← Esto crea: BIGINT UNSIGNED AUTO_INCREMENT + PK

            $table->unsignedBigInteger('restaurant_area_id');
            $table->unsignedBigInteger('table_id');

            $table->timestamps();

            // Índice único
            $table->unique(['table_id', 'restaurant_area_id'], 'unique_table_area');

            // Claves foráneas
            $table->foreign('restaurant_area_id')
                  ->references('id')
                  ->on('restaurant_areas')
                  ->onDelete('cascade');

            $table->foreign('table_id')
                  ->references('id')
                  ->on('tables')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('area_tables');
    }
};