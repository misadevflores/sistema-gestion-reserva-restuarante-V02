<?php

namespace App\Filament\Resources\MenuItemOptions\Pages;

use App\Filament\Resources\MenuItemOptions\MenuItemOptionResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditMenuItemOption extends EditRecord
{
    protected static string $resource = MenuItemOptionResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
