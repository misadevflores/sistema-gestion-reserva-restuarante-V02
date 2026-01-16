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
                Forms\Components\Select::make('restaurant_id')
                ->relationship('restaurant', 'name')
                ->required(),
            Forms\Components\Select::make('table_id')
                ->relationship('table', 'name')
                ->nullable(),
            Forms\Components\TextInput::make('customer_name')->required(),
            Forms\Components\TextInput::make('customer_email')->email()->required(),
            Forms\Components\TextInput::make('customer_phone')->required(),
            Forms\Components\TextInput::make('party_size')->numeric()->required(),
            Forms\Components\DatePicker::make('date')->required(),
            Forms\Components\TimePicker::make('start_time')->required(),
            Forms\Components\TimePicker::make('end_time')->required(),
            Forms\Components\TextInput::make('duration')->numeric()->required(),
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
