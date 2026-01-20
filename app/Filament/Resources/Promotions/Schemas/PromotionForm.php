<?php

namespace App\Filament\Resources\Promotions\Schemas;

use Filament\Schemas\Schema;
use Filament\Forms;
use Filament\Forms\Form;
class PromotionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
               Forms\Components\Select::make('restaurant_id')
                    ->relationship('restaurant', 'name')
                    ->required()
                    ->label('Restaurante'),
                Forms\Components\TextInput::make('title')
                    ->required()
                    ->label('Título'),
                Forms\Components\Textarea::make('description')
                    ->required()
                    ->label('Descripción'),
                Forms\Components\FileUpload::make('image_path')
                    ->image()
                    ->directory('promotions')
                    ->label('Imagen'),
                Forms\Components\DatePicker::make('start_date')->required(),
                Forms\Components\DatePicker::make('end_date')
                    ->required()
                    ->label('Fecha de Fin'),
                Forms\Components\Toggle::make('is_active')
                    ->default(true)
                    ->label('Activa'),
                Forms\Components\Select::make('promotion_type')
                    ->options([
                        'menu' => 'Menú especial',
                        'discount' => 'Descuento',
                        'event' => 'Evento',
                        'announcement' => 'Anuncio',
                    ])
                    ->required()
                    ->label('Tipo de Promoción'),
                Forms\Components\TextInput::make('target_url'),
            ]);
    }
}
