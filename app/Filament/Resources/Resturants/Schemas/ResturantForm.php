<?php

namespace App\Filament\Resources\Resturants\Schemas;

use Filament\Schemas\Schema;
use Filament\Forms;
use Filament\Actions\Action;
use App\Models\Restaurant;
use Illuminate\Support\Str;
class ResturantForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                  Forms\Components\Select::make('user_id')
                ->relationship('user', 'name')
                ->required(),
                Forms\Components\TextInput::make('name')
                    ->required(),
                Forms\Components\TextInput::make('slug')
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->suffixAction(
                        Forms\Components\Actions\Action::make('generateSlug')
                            ->icon('heroicon-o-arrow-path')
                            ->action(function (callable $get, callable $set) {
                                $name = $get('name');
                                if ($name) {
                                    $slug = Str::slug($name);
                                    $originalSlug = $slug;
                                    $count = 1;
                                    while (\App\Models\Restaurant::where('slug', $slug)->exists()) {
                                        $slug = $originalSlug . '-' . $count;
                                        $count++;
                                    }
                                    $set('slug', $slug);
                                }
                            })
                    ),
                Forms\Components\Textarea::make('description'),
                Forms\Components\TextInput::make('address')->required(),
                Forms\Components\TextInput::make('city'),
                Forms\Components\TextInput::make('phone'),
                Forms\Components\TextInput::make('email'),
                Forms\Components\TimePicker::make('open_time')->required(),
                Forms\Components\TimePicker::make('close_time')->required(),
                Forms\Components\TextInput::make('default_reservation_duration')->numeric()->default(90),
                Forms\Components\TextInput::make('cleanup_buffer_minutes')->numeric()->default(15),
                Forms\Components\Toggle::make('accepts_walk_ins')->default(true),
                Forms\Components\Toggle::make('is_active')->default(true),
            ]);
    }
}
