<x-filament-panels::page>
    <div class="space-y-6">
        @livewire('saade.filament-full-calendar.widgets.full-calendar-widget', [
            'events' => $this->getEvents(),
        ])
    </div>
</x-filament-panels::page>
