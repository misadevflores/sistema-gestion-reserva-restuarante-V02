<?php

namespace App\Filament\Resources\Resturants\Pages;

use App\Filament\Resources\Resturants\ResturantResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListResturants extends ListRecords
{
    protected static string $resource = ResturantResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
