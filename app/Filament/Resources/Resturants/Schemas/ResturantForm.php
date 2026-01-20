<?php

namespace App\Filament\Resources\Resturants\Schemas;

use Filament\Schemas\Schema;
use Filament\Forms;
use Filament\Actions\Action;
use Filament\Schemas\Get;
// use Filament\Schemas\Set;
use Filament\Schemas\Components\Utilities\Set;
use App\Models\Restaurant;
use Illuminate\Support\Str;
use Filament\Forms\Components\Tabs;
use Filament\Forms\Components\Repeater;
class ResturantForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Tabs::make('Restaurant Configuration')
                    ->tabs([
                        Tabs\Tab::make('Basic Information')
                            ->schema([
                                Forms\Components\Select::make('user_id')
                                    ->relationship('user', 'name')
                                    ->label('Propietario')
                                    ->required(),

                                Forms\Components\TextInput::make('name')
                                    ->live(onBlur: true)
                                    ->afterStateUpdated(function (Set $set, ?string $state) {
                                        $set('slug', Str::slug($state));
                                    })
                                    ->required()
                                    ->label('Nombre del Restaurante'),

                                Forms\Components\TextInput::make('slug')
                                    ->required()
                                    ->label('Slug'),

                                Forms\Components\Textarea::make('description')->label('Descripción'),
                                Forms\Components\TextInput::make('address')->required()->label('Dirección'),
                                Forms\Components\TextInput::make('city')->label('Ciudad'),
                                Forms\Components\TextInput::make('phone')->label('Teléfono'),
                                Forms\Components\TextInput::make('email')->label('Correo Electrónico'),
                                Forms\Components\TimePicker::make('open_time')->required()->label('Hora de Apertura'),
                                Forms\Components\TimePicker::make('close_time')->required()->label('Hora de Cierre'),
                                Forms\Components\TextInput::make('default_reservation_duration')->label('Duración por Defecto')->numeric()->default(90),
                                Forms\Components\TextInput::make('cleanup_buffer_minutes')->label('Buffer de Limpieza (minutos)')->numeric()->default(15),
                                Forms\Components\Toggle::make('accepts_walk_ins')->default(true)->label('Acepta Walk-ins'),
                                Forms\Components\Toggle::make('is_active')->default(true)->label('Activo'),
                            ]),

                        Tabs\Tab::make('Areas & Tables')
                            ->schema([
                                Repeater::make('restaurantAreas')
                                    ->relationship('restaurantAreas')
                                    ->schema([
                                        Forms\Components\TextInput::make('name')
                                            ->required()
                                            ->label('Nombre del Área'),
                                        Forms\Components\Textarea::make('description')
                                            ->nullable()
                                            ->label('Descripción'),
                                        Forms\Components\TextInput::make('sort_order')
                                            ->numeric()
                                            ->default(0)
                                            ->label('Orden'),
                                        Forms\Components\Toggle::make('status')
                                            ->default(true)
                                            ->label('Activo'),
                                    ])
                                    ->columns(2)
                                    ->label('Áreas del Restaurante')
                                    ->collapsible()
                                    ->itemLabel(fn (array $state): ?string => $state['name'] ?? null),

                                Repeater::make('tables')
                                    ->relationship('tables')
                                    ->schema([
                                        Forms\Components\TextInput::make('name')
                                            ->required()
                                            ->label('Nombre de la Mesa'),
                                        Forms\Components\TextInput::make('capacity')
                                            ->required()
                                            ->numeric()
                                            ->label('Capacidad'),
                                        Forms\Components\TextInput::make('min_capacity')
                                            ->numeric()
                                            ->nullable()
                                            ->label('Capacidad Mínima'),
                                        Forms\Components\Select::make('restaurant_area_id')
                                            ->relationship('restaurantArea', 'name')
                                            ->nullable()
                                            ->label('Área del Restaurante'),
                                        Forms\Components\Select::make('location')
                                            ->options([
                                                'indoor' => 'Interior',
                                                'outdoor' => 'Exterior',
                                                'bar' => 'Bar',
                                            ])
                                            ->nullable()
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
                                            ->label('Activa')
                                            ->default(true),
                                    ])
                                    ->columns(3)
                                    ->label('Mesas')
                                    ->collapsible()
                                    ->itemLabel(fn (array $state): ?string => $state['name'] ?? null),
                            ]),
                    ])
                    ->columnSpanFull(),
            ]);
    }
}




