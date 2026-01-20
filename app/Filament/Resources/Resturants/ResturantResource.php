<?php

namespace App\Filament\Resources\Resturants;

use App\Filament\Resources\Resturants\Pages\CreateResturant;
use App\Filament\Resources\Resturants\Pages\EditResturant;
use App\Filament\Resources\Resturants\Pages\ListResturants;
use App\Filament\Resources\Resturants\Schemas\ResturantForm;
use App\Filament\Resources\Resturants\Tables\ResturantsTable;
use App\Filament\Resources\Resturants\Relations\TablesRelationManager;
use App\Filament\Resources\Resturants\Relations\RestaurantAreasRelationManager;
use App\Filament\Resources\Resturants\Relations\RestaurantEventsRelationManager;
use App\Filament\Resources\Resturants\Relations\TypeEventsRelationManager;
use App\Models\Restaurant;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class ResturantResource extends Resource
{
    protected static ?string $model = Restaurant::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedBuildingStorefront;

    protected static ?string $navigationLabel = 'Restaurantes';

    protected static ?string $recordTitleAttribute = 'Restaurante';

    protected static string|\UnitEnum|null $navigationGroup = 'Gestion de reserva';

    protected static ?int $navigationSort = 1;

    public static function form(Schema $schema): Schema
    {
        return ResturantForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return ResturantsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            TablesRelationManager::class,
            RestaurantAreasRelationManager::class,
            RestaurantEventsRelationManager::class,
            TypeEventsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListResturants::route('/'),
            'create' => CreateResturant::route('/create'),
            'edit' => EditResturant::route('/{record}/edit'),
        ];
    }
}
