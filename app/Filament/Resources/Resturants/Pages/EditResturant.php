<?php

namespace App\Filament\Resources\Resturants\Pages;

use App\Filament\Resources\Resturants\ResturantResource;
use Filament\Actions\DeleteAction;
use Filament\Actions\Action;
use Filament\Resources\Pages\EditRecord;
use Filament\Schemas\Schema;
use Filament\Forms;

class EditResturant extends EditRecord
{
    protected static string $resource = ResturantResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Action::make('settings')
                ->label('Configuración')
                ->icon('heroicon-o-cog')
                ->color('gray')
                ->action(function () {
                    // Placeholder for settings action
                    // Could open a modal or redirect to settings
                }),
            DeleteAction::make(),
        ];
    }
}
