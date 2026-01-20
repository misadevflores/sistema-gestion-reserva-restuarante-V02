<?php

namespace App\Filament\Resources\Resturants\Relations;

use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Schemas\Schema;
use Filament\Forms;

class TablesRelationManager extends RelationManager
{
    protected static string $relationship = 'tables';

    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Forms\Components\TextInput::make('name')
                    ->required()
                    ->maxLength(255)
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
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('name')
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label('Nombre'),

                Tables\Columns\TextColumn::make('capacity')
                    ->label('Capacidad'),

                Tables\Columns\TextColumn::make('min_capacity')
                    ->label('Capacidad Mínima'),

                Tables\Columns\TextColumn::make('restaurantArea.name')
                    ->label('Área'),

                Tables\Columns\TextColumn::make('location')
                    ->label('Ubicación')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'indoor' => 'success',
                        'outdoor' => 'warning',
                        'bar' => 'info',
                        default => 'gray',
                    }),

                Tables\Columns\TextColumn::make('status')
                    ->label('Estado')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'available' => 'success',
                        'maintenance' => 'warning',
                        'blocked' => 'danger',
                        default => 'gray',
                    }),

                Tables\Columns\IconColumn::make('is_active')
                    ->boolean()
                    ->label('Activa'),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('status')
                    ->options([
                        'available' => 'Disponible',
                        'maintenance' => 'Mantenimiento',
                        'blocked' => 'Bloqueada',
                    ])
                    ->label('Estado'),

                Tables\Filters\SelectFilter::make('location')
                    ->options([
                        'indoor' => 'Interior',
                        'outdoor' => 'Exterior',
                        'bar' => 'Bar',
                    ])
                    ->label('Ubicación'),

                Tables\Filters\TernaryFilter::make('is_active')
                    ->label('Activa'),
            ])
            ->headerActions([
                Tables\Actions\CreateAction::make(),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }
}
