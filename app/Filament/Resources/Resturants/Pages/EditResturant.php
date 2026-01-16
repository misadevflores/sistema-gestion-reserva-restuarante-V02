<?php

namespace App\Filament\Resources\Resturants\Pages;

use App\Filament\Resources\Resturants\ResturantResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditResturant extends EditRecord
{
    protected static string $resource = ResturantResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
