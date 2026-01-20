<?php

namespace App\Filament\Resources\MenuItemOptionValues\Pages;

use App\Filament\Resources\MenuItemOptionValues\MenuItemOptionValueResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListMenuItemOptionValues extends ListRecords
{
    protected static string $resource = MenuItemOptionValueResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
