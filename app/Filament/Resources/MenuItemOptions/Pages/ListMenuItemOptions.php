<?php

namespace App\Filament\Resources\MenuItemOptions\Pages;

use App\Filament\Resources\MenuItemOptions\MenuItemOptionResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListMenuItemOptions extends ListRecords
{
    protected static string $resource = MenuItemOptionResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
