<?php

namespace App\Filament\Resources\Reservations\Pages;

use App\Models\Reservation;
use Filament\Resources\Pages\Page;
use Saade\FilamentFullCalendar\Widgets\FullCalendarWidget;

class CalendarReservations extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-calendar-days';

    protected static string $view = 'filament.resources.reservations.pages.calendar-reservations';

    protected static ?string $title = 'Calendario de Reservaciones';

    public function getHeaderWidgets(): array
    {
        return [
            FullCalendarWidget::make()
                ->events(function () {
                    return Reservation::all()->map(function ($reservation) {
                        return [
                            'title' => $reservation->customer_name . ' - ' . $reservation->party_size . ' personas',
                            'start' => $reservation->date . 'T' . $reservation->start_time,
                            'end' => $reservation->date . 'T' . $reservation->end_time,
                            'backgroundColor' => $reservation->status === 'confirmed' ? '#10b981' : ($reservation->status === 'pending' ? '#f59e0b' : '#ef4444'),
                            'borderColor' => $reservation->status === 'confirmed' ? '#10b981' : ($reservation->status === 'pending' ? '#f59e0b' : '#ef4444'),
                        ];
                    })->toArray();
                }),
        ];
    }
}
