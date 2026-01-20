<?php

namespace App\Filament\Resources\Tables\Schemas;

use Filament\Schemas\Components\NumberInput;
use Filament\Schemas\Components\Select;
use Filament\Schemas\Components\TextInput;
use Filament\Schemas\Components\Toggle;
use Filament\Schemas\Schema;
use Filament\Forms;
class TableForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Forms\Components\Select::make('restaurant_id')
                    ->relationship('restaurant', 'name')
                    ->required()
                    ->label('Restaurante'),

                Forms\Components\TextInput::make('name')
                    ->required()
                    ->label('Nombre de la Mesa'),

                Forms\Components\TextInput::make('capacity')
                    ->required()
                     ->numeric() // Obliga a que el valor sea un número
                    ->minValue(1)
                    ->label('Capacidad'),

                Forms\Components\TextInput::make('min_capacity')
                    ->minValue(1)
                     ->numeric() // Obliga a que el valor sea un número
                    ->label('Capacidad Mínima'),

                Forms\Components\Select::make('location')
                    ->options([
                        'indoor' => 'Interior',
                        'outdoor' => 'Exterior',
                        'bar' => 'Bar',
                    ])
                    ->required()
                    ->label('Ubicación'),

                Forms\Components\Select::make('status')
                    ->options([
                        'available' => 'Disponible',
                        'maintenance' => 'Mantenimiento',
                        'blocked' => 'Bloqueada',
                    ])
                    ->default('available')
                    ->required()
                    ->label('Estado'),

                Forms\Components\Toggle::make('is_active')
                    ->default(true)
                    ->label('Activa'),
            ]);
    }
}
