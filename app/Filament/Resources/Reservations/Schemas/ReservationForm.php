<?php

namespace App\Filament\Resources\Reservations\Schemas;

use Filament\Schemas\Schema;

use Filament\Forms;

class ReservationForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                //
                Forms\Components\TextInput::make('codigo')
                ->readOnly() // o ->readOnly()
                ->default(fn () => 'RES-' . strtoupper(uniqid())) // Generar un código único
                ->dehydrated(false), // importante: no enviar al guardar
                Forms\Components\Select::make('restaurant_id')
                ->relationship('restaurant', 'name')
                ->label('Restuarante')
                ->required(),
            Forms\Components\Select::make('table_id')
                ->relationship('table', 'name')
                ->nullable()
                ->label('Mesa'),
            Forms\Components\TextInput::make('customer_name')->required()->label('Nombre del Cliente'),
            Forms\Components\TextInput::make('customer_email')->email()->label('Correo Electrónico (Opcional)'),
            Forms\Components\TextInput::make('customer_phone')->required()->label('Teléfono del Cliente'),
            Forms\Components\TextInput::make('party_size')->numeric()->required()->label('Cantidad de Personas'),
            Forms\Components\DatePicker::make('date')->required()->label('Fecha de la Reserva'),
            Forms\Components\TimePicker::make('start_time')->required()->label('Hora de Inicio'),
            Forms\Components\TimePicker::make('end_time')->label('Hora de Fin (Opcional)'),
            Forms\Components\TextInput::make('duration')->numeric()->label('Duración (Opcional)'),
            Forms\Components\Select::make('status')
                ->options([
                    'pending' => 'Pendiente',
                    'confirmed' => 'Confirmada',
                    'cancelled' => 'Cancelada',
                    'completed' => 'Completada',
                ])->required(),
            Forms\Components\Textarea::make('notes'),
            Forms\Components\Select::make('reservation_type')
                ->options([
                    'regular' => 'Regular',
                    'birthday' => 'Cumpleaños',
                    'wedding' => 'Boda',
                    'graduation' => 'Graduación',
                    'corporate' => 'Corporativo',
                    'other' => 'Otro',
                ])->required(),
            ]);
    }
}
