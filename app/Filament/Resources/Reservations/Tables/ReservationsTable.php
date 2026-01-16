<?php

namespace App\Filament\Resources\Reservations\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Table;
use Filament\Tables;
class ReservationsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                //
                 Tables\Columns\TextColumn::make('customer_name'),
            Tables\Columns\TextColumn::make('restaurant.name'),
            Tables\Columns\TextColumn::make('date'),
            Tables\Columns\TextColumn::make('start_time'),
            Tables\Columns\TextColumn::make('party_size'),
            Tables\Columns\TextColumn::make('status'),
            Tables\Columns\TextColumn::make('reservation_type')
                ->badge()
                ->color(fn (string $state): string => match ($state) {
                    'regular' => 'gray',
                    'birthday' => 'pink',
                    'wedding' => 'rose',
                    'graduation' => 'blue',
                    'corporate' => 'green',
                    default => 'gray',
                }),
            ])
            ->filters([
                //
                Tables\Filters\SelectFilter::make('restaurant_id')
                ->relationship('restaurant', 'name'),
            Tables\Filters\SelectFilter::make('reservation_type')
                ->options([
                    'regular' => 'Regular',
                    'birthday' => 'Cumpleaños',
                    'wedding' => 'Boda',
                    'graduation' => 'Graduación',
                    'corporate' => 'Corporativo',
                ]),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
