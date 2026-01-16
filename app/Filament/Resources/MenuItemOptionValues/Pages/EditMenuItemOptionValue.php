<?php

namespace App\Filament\Resources\MenuItemOptionValues\Pages;

use App\Filament\Resources\MenuItemOptionValues\MenuItemOptionValueResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditMenuItemOptionValue extends EditRecord
{
    protected static string $resource = MenuItemOptionValueResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
