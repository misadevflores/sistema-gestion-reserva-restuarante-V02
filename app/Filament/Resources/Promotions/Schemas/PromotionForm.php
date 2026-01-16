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
                    ->required(),
                Forms\Components\TextInput::make('title')->required(),
                Forms\Components\Textarea::make('description')->required(),
                Forms\Components\FileUpload::make('image_path')
                    ->image()
                    ->directory('promotions'),
                Forms\Components\DatePicker::make('start_date')->required(),
                Forms\Components\DatePicker::make('end_date')->required(),
                Forms\Components\Toggle::make('is_active')->default(true),
                Forms\Components\Select::make('promotion_type')
                    ->options([
                        'menu' => 'Menú especial',
                        'discount' => 'Descuento',
                        'event' => 'Evento',
                        'announcement' => 'Anuncio',
                    ])->required(),
                Forms\Components\TextInput::make('target_url'),
            ]);
    }
}
