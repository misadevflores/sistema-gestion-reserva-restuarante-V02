<?php

namespace App\Filament\Resources\MenuItemOptionValues;

use App\Filament\Resources\MenuItemOptionValues\Pages\CreateMenuItemOptionValue;
use App\Filament\Resources\MenuItemOptionValues\Pages\EditMenuItemOptionValue;
use App\Filament\Resources\MenuItemOptionValues\Pages\ListMenuItemOptionValues;
use App\Filament\Resources\MenuItemOptionValues\Schemas\MenuItemOptionValueForm;
use App\Filament\Resources\MenuItemOptionValues\Tables\MenuItemOptionValuesTable;
use App\Models\Menu\MenuItemOptionValue;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use Filament\Tables;


class MenuItemOptionValueResource extends Resource
{
    protected static ?string $model = MenuItemOptionValue::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedListBullet;

    protected static string|\UnitEnum|null $navigationGroup = 'Gestion de menu';

    protected static ?string $recordTitleAttribute = 'value';

    public static function form(Schema $schema): Schema
    {
        return MenuItemOptionValueForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return MenuItemOptionValuesTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListMenuItemOptionValues::route('/'),
            'create' => CreateMenuItemOptionValue::route('/create'),
            'edit' => EditMenuItemOptionValue::route('/{record}/edit'),
        ];
    }
}
