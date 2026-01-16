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
                    ->label('Restaurant'),

                Forms\Components\TextInput::make('name')
                    ->required()
                    ->label('Table Name'),

                Forms\Components\TextInput::make('capacity')
                    ->required()
                     ->numeric() // Obliga a que el valor sea un número
                    ->minValue(1)
                    ->label('Capacity'),

                Forms\Components\TextInput::make('min_capacity')
                    ->minValue(1)
                     ->numeric() // Obliga a que el valor sea un número
                    ->label('Minimum Capacity'),

                Forms\Components\Select::make('location')
                    ->options([
                        'indoor' => 'Indoor',
                        'outdoor' => 'Outdoor',
                        'bar' => 'Bar',
                    ])
                    ->required()
                    ->label('Location'),

                Forms\Components\Select::make('status')
                    ->options([
                        'available' => 'Available',
                        'maintenance' => 'Maintenance',
                        'blocked' => 'Blocked',
                    ])
                    ->default('available')
                    ->required()
                    ->label('Status'),

                Forms\Components\Toggle::make('is_active')
                    ->default(true)
                    ->label('Active'),
            ]);
    }
}
