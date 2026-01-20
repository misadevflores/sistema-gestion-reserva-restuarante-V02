
-- SCRIPT ORGANIZADO DE BASE DE DATOS PARA SISTEMA DE RESERVAS DE RESTAURANTES
-- --------------------------------------------------------
-- Tabla: restaurants
-- Almacena la información básica de cada restaurante del sistema.
-- Cada restaurante tiene un propietario (user_id) y su configuración
-- de horarios, capacidad y políticas de reservas.
-- --------------------------------------------------------
CREATE TABLE restaurants (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id bigint UNSIGNED NOT NULL, -- ID del usuario propietario del restaurante
    name varchar(255) NOT NULL, -- Nombre comercial del restaurante
    slug varchar(255) NOT NULL UNIQUE, -- URL amigable para el perfil del restaurante
    description text NULL, -- Descripción detallada del restaurante
    address varchar(255) NOT NULL, -- Dirección física del restaurante
    city varchar(255) NULL, -- Ciudad donde se ubica el restaurante
    phone varchar(255) NULL, -- Teléfono de contacto del restaurante
    email varchar(255) NULL, -- Correo electrónico del restaurante
    open_time time NOT NULL, -- Hora de apertura habitual del restaurante
    close_time time NOT NULL, -- Hora de cierre habitual del restaurante
    default_reservation_duration int NOT NULL DEFAULT 90, -- Duración estándar de una reserva en minutos
    cleanup_buffer_minutes int NOT NULL DEFAULT 15, -- Tiempo mínimo entre reservas para limpieza/preparación
    accepts_walk_ins tinyint(1) NOT NULL DEFAULT 1, -- Indica si acepta clientes sin reserva previa
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado del restaurante (1=activo, 0=inactivo)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: areas
-- Define las diferentes zonas o áreas dentro de un restaurante.
-- Permite organizar las mesas por ubicación (terraza, interior, bar, etc.)
-- y aplicar configuraciones específicas por área.
-- --------------------------------------------------------
CREATE TABLE areas (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante al que pertenece esta área
    name varchar(255) NOT NULL, -- Nombre descriptivo del área (ej: "Terraza", "Salón Principal")
    description text NULL, -- Descripción detallada del área
    location varchar(255) NULL, -- Tipo de ubicación: 'indoor', 'outdoor', 'bar', 'private_room', etc.
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado del área (1=activa, 0=inactiva)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: tables (mesas)
-- Almacena información sobre cada mesa individual del restaurante.
-- Cada mesa tiene una capacidad específica y está asociada a un área.
-- El estado permite saber si la mesa está disponible, ocupada o en mantenimiento.
-- --------------------------------------------------------
CREATE TABLE tables (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante al que pertenece esta mesa
    area_id bigint UNSIGNED NULL, -- ID del área donde se encuentra esta mesa (puede ser nulo)
    name varchar(255) NOT NULL, -- Nombre o número identificador de la mesa
    capacity int NOT NULL, -- Capacidad máxima de comensales en la mesa
    min_capacity int NULL, -- Capacidad mínima preferida para esta mesa
    status varchar(255) NOT NULL DEFAULT 'available', -- Estado: 'available', 'occupied', 'maintenance', 'blocked'
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Indica si la mesa está actualmente en uso (1=activa, 0=inactiva)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (area_id) REFERENCES areas(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: reservation_types
-- Define los diferentes tipos de reservas que puede gestionar el sistema.
-- Permite distinguir entre reservas regulares, eventos especiales, etc.
-- Cada tipo puede tener configuraciones especiales asociadas.
-- --------------------------------------------------------
CREATE TABLE reservation_types (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL, -- Nombre del tipo de reserva (ej: "Regular", "Cumpleaños", "Evento Corporativo")
    description text NULL, -- Descripción detallada de este tipo de reserva
    requires_special_configuration BOOLEAN DEFAULT FALSE, -- Indica si necesita configuración especial
    is_active BOOLEAN NOT NULL DEFAULT TRUE, -- Estado del tipo de reserva
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: reservations
-- Es la tabla central del sistema que almacena todas las reservas realizadas.
-- Contiene información del cliente, detalles de la reserva y estado actual.
-- Permite asignar una mesa específica o dejarla sin asignar inicialmente.
-- --------------------------------------------------------
CREATE TABLE reservations (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante donde se realiza la reserva
    table_id bigint UNSIGNED NULL, -- ID de la mesa asignada (puede ser NULL si no se asigna aún)
    reservation_type_id bigint UNSIGNED NOT NULL, -- ID del tipo de reserva
    codigo varchar(10) NOT NULL, -- Código único de referencia para la reserva
    customer_name varchar(255) NOT NULL, -- Nombre del cliente que realiza la reserva
    customer_email varchar(255) NULL, -- Correo electrónico del cliente
    customer_phone varchar(255) NULL, -- Teléfono de contacto del cliente
    party_size int NOT NULL, -- Número de personas en la reserva
    reservation_date date NOT NULL, -- Fecha de la reserva
    start_time time NOT NULL, -- Hora de inicio de la reserva
    end_time time NOT NULL, -- Hora de fin de la reserva
    duration int NULL, -- Duración en minutos (calculada automáticamente)
    status varchar(255) NOT NULL DEFAULT 'pending', -- Estado: 'pending', 'confirmed', 'cancelled', 'completed', 'no_show'
    notes text NULL, -- Notas adicionales sobre la reserva
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE SET NULL,
    FOREIGN KEY (reservation_type_id) REFERENCES reservation_types(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: events
-- Almacena información sobre eventos especiales programados en los restaurantes.
-- Los eventos pueden afectar la disponibilidad de mesas o áreas completas.
-- Se relaciona con reservation_types para clasificar el tipo de evento.
-- --------------------------------------------------------
CREATE TABLE events (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante donde se realiza el evento
    reservation_type_id bigint UNSIGNED NOT NULL, -- ID del tipo de evento
    name varchar(255) NOT NULL, -- Nombre del evento
    description text NULL, -- Descripción detallada del evento
    start_date datetime NOT NULL, -- Fecha y hora de inicio del evento
    end_date datetime NOT NULL, -- Fecha y hora de fin del evento
    capacity int NULL, -- Capacidad máxima del evento (si aplica)
    is_active BOOLEAN NOT NULL DEFAULT TRUE, -- Estado del evento
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (reservation_type_id) REFERENCES reservation_types(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: event_areas (continuación)
-- Tabla intermedia que relaciona eventos con áreas específicas del restaurante.
-- Permite asignar áreas completas a eventos y definir capacidades específicas
-- para cada área durante el evento.
-- --------------------------------------------------------
CREATE TABLE event_areas (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    event_id bigint UNSIGNED NOT NULL, -- ID del evento
    area_id bigint UNSIGNED NOT NULL, -- ID del área asignada al evento
    capacity_assigned int NULL, -- Capacidad específica asignada para esta área en el evento
    is_active BOOLEAN NOT NULL DEFAULT TRUE, -- Estado de la asignación
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (area_id) REFERENCES areas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menus
-- Almacena los diferentes menús disponibles en cada restaurante.
-- Un restaurante puede tener múltiples menús (carta principal, menú del día,
-- menú infantil, etc.) con diferentes períodos de vigencia.
-- --------------------------------------------------------
CREATE TABLE menus (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante al que pertenece este menú
    name varchar(255) NOT NULL DEFAULT 'Carta principal', -- Nombre descriptivo del menú
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado del menú (1=activo, 0=inactivo)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_categories
-- Organiza los platos del menú en categorías lógicas (entrantes, principales,
-- postres, bebidas, etc.). Cada categoría pertenece a un menú específico.
-- El campo sort_order permite definir el orden en que se mostrarán las categorías.
-- --------------------------------------------------------
CREATE TABLE menu_categories (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    menu_id bigint UNSIGNED NOT NULL, -- ID del menú al que pertenece esta categoría
    name varchar(255) NOT NULL, -- Nombre de la categoría
    description text NULL, -- Descripción detallada de la categoría
    sort_order int NOT NULL DEFAULT 0, -- Orden de visualización (menor número aparece primero)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_items
-- Contiene los platos individuales disponibles en el menú.
-- Cada plato pertenece a una categoría específica y tiene información
-- detallada como precio, descripción, alérgenos y tiempo de preparación.
-- El campo is_available permite activar/desactivar platos temporalmente.
-- --------------------------------------------------------
CREATE TABLE menu_items (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    category_id bigint UNSIGNED NOT NULL, -- ID de la categoría a la que pertenece este plato
    name varchar(255) NOT NULL, -- Nombre del plato
    description text NULL, -- Descripción detallada del plato
    price decimal(8,2) NOT NULL, -- Precio del plato
    image_path varchar(255) NULL, -- Ruta de la imagen del plato
    is_available tinyint(1) NOT NULL DEFAULT 1, -- Disponibilidad actual (1=disponible, 0=no disponible)
    prep_time_minutes int NULL, -- Tiempo estimado de preparación en minutos
    allergens varchar(255) NULL, -- Lista de alérgenos separados por comas (ej: "gluten,lactosa,frutos secos")
    sort_order int NOT NULL DEFAULT 0, -- Orden de visualización dentro de la categoría
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (category_id) REFERENCES menu_categories(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_item_options
-- Define opciones personalizables para los platos del menú.
-- Permite configurar elecciones como "tipo de cocción", "acompañamientos",
-- "intensidad de picante", etc. Puede ser obligatoria u opcional.
-- El campo allow_multiple determina si se puede seleccionar más de una opción.
-- --------------------------------------------------------
CREATE TABLE menu_item_options (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    item_id bigint UNSIGNED NOT NULL, -- ID del plato al que pertenece esta opción
    name varchar(255) NOT NULL, -- Nombre de la opción (ej: "Tipo de cocción")
    is_required tinyint(1) NOT NULL DEFAULT 0, -- Indica si es obligatorio seleccionar esta opción
    allow_multiple tinyint(1) NOT NULL DEFAULT 0, -- Indica si se permiten múltiples selecciones
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (item_id) REFERENCES menu_items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_item_option_values
-- Almacena los valores posibles para cada opción de personalización.
-- Por ejemplo, para la opción "Tipo de cocción" podría tener valores
-- como "Poco hecho", "Al punto", "Bien hecho" con sus respectivos
-- ajustes de precio. El campo is_default define la opción preseleccionada.
-- --------------------------------------------------------
CREATE TABLE menu_item_option_values (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    option_id bigint UNSIGNED NOT NULL, -- ID de la opción a la que pertenece este valor
    label varchar(255) NOT NULL, -- Etiqueta descriptiva del valor
    price_adjustment decimal(8,2) NOT NULL DEFAULT 0.00, -- Ajuste de precio (positivo o negativo)
    is_default tinyint(1) NOT NULL DEFAULT 0, -- Indica si es la opción preseleccionada
    stock int NULL, -- Stock disponible (NULL si es ilimitado)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (option_id) REFERENCES menu_item_options(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: promotions
-- Gestiona las promociones y ofertas especiales de los restaurantes.
-- Puede incluir descuentos, menús especiales, eventos promocionales, etc.
-- El campo promotion_type permite clasificar las promociones según su naturaleza.
-- --------------------------------------------------------
CREATE TABLE promotions (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante que ofrece la promoción
    title varchar(255) NOT NULL, -- Título breve de la promoción
    description text NOT NULL, -- Descripción detallada de la promoción
    image_path varchar(255) NULL, -- Ruta de la imagen promocional
    start_date date NOT NULL, -- Fecha de inicio de la promoción
    end_date date NOT NULL, -- Fecha de fin de la promoción
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado de la promoción (1=activa, 0=inactiva)
    promotion_type varchar(255) NOT NULL, -- Tipo: 'menu', 'discount', 'event', 'announcement'
    target_url varchar(255) NULL, -- URL de destino al hacer clic en la promoción
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: customers (continuación)
-- Almacena información de los clientes que realizan reservas.
-- Permite mantener un historial de visitas, preferencias y datos de contacto
-- para mejorar la experiencia del cliente y facilitar futuras reservas.
-- --------------------------------------------------------
CREATE TABLE customers (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL, -- Nombre del cliente
    email varchar(255) NULL, -- Correo electrónico del cliente
    phone varchar(255) NULL, -- Teléfono de contacto del cliente
    birth_date date NULL, -- Fecha de nacimiento (para promociones de cumpleaños)
    preferences text NULL, -- Preferencias especiales del cliente (ej: "mesa cerca de ventana", "sin gluten")
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado del cliente (1=activo, 0=inactivo)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: customer_visits
-- Registra cada visita de un cliente al restaurante, ya sea mediante reserva
-- o como cliente sin reserva (walk-in). Permite analizar patrones de visita,
-- frecuencia y preferencias horarias de cada cliente.
-- --------------------------------------------------------
CREATE TABLE customer_visits (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id bigint UNSIGNED NOT NULL, -- ID del cliente que visitó
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante visitado
    reservation_id bigint UNSIGNED NULL, -- ID de la reserva (puede ser NULL si fue walk-in)
    visit_date date NOT NULL, -- Fecha de la visita
    arrival_time time NULL, -- Hora de llegada real del cliente
    departure_time time NULL, -- Hora de salida del cliente
    party_size int NOT NULL, -- Número real de personas en la visita
    table_id bigint UNSIGNED NULL, -- Mesa asignada durante la visita
    total_amount decimal(10,2) NULL, -- Importe total consumido
    rating int NULL, -- Calificación dada por el cliente (1-5)
    comments text NULL, -- Comentarios del cliente sobre la experiencia
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE SET NULL,
    FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: notifications
-- Gestiona las notificaciones enviadas a los clientes relacionadas con
-- sus reservas (confirmaciones, recordatorios, cancelaciones, etc.).
-- Permite registrar el tipo de comunicación, el canal utilizado y el estado.
-- --------------------------------------------------------
CREATE TABLE notifications (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id bigint UNSIGNED NOT NULL, -- ID del cliente destinatario
    reservation_id bigint UNSIGNED NULL, -- ID de la reserva relacionada (si aplica)
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante que envía la notificación
    type varchar(50) NOT NULL, -- Tipo: 'confirmation', 'reminder', 'cancellation', 'promotion'
    channel varchar(50) NOT NULL, -- Canal: 'email', 'sms', 'push'
    subject varchar(255) NULL, -- Asunto de la notificación
    content text NOT NULL, -- Contenido del mensaje
    status varchar(50) NOT NULL DEFAULT 'pending', -- Estado: 'pending', 'sent', 'failed'
    sent_at timestamp NULL, -- Fecha y hora de envío
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE SET NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: availability_exceptions
-- Permite definir excepciones en la disponibilidad habitual del restaurante.
-- Útil para días festivos, eventos especiales, cierros temporales, etc.
-- Afecta la capacidad total del restaurante o de áreas específicas.
-- --------------------------------------------------------
CREATE TABLE availability_exceptions (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante afectado
    area_id bigint UNSIGNED NULL, -- ID del área afectada (NULL si afecta a todo el restaurante)
    exception_date date NOT NULL, -- Fecha de la excepción
    open_time time NULL, -- Hora de apertura especial (NULL si cierra ese día)
    close_time time NULL, -- Hora de cierre especial (NULL si cierra ese día)
    capacity_percentage int NULL, -- Porcentaje de capacidad habitual (100=normal, 50=mitad, NULL=cerrado)
    reason varchar(255) NULL, -- Motivo de la excepción
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado de la excepción
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (area_id) REFERENCES areas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: waiting_list
-- Gestiona la lista de espera para clientes sin reserva.
-- Permite organizar a los clientes por orden de llegada y estimar
-- tiempos de espera basados en las mesas disponibles y reservas próximas.
-- --------------------------------------------------------
CREATE TABLE waiting_list (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante
    customer_id bigint UNSIGNED NULL, -- ID del cliente (si está registrado)
    customer_name varchar(255) NOT NULL, -- Nombre del cliente
    customer_phone varchar(255) NULL, -- Teléfono de contacto
    party_size int NOT NULL, -- Número de personas
    arrival_time time NOT NULL, -- Hora de llegada a la lista de espera
    estimated_wait_time int NULL, -- Tiempo estimado de espera en minutos
    status varchar(50) NOT NULL DEFAULT 'waiting', -- Estado: 'waiting', 'seated', 'cancelled', 'no_show'
    notes text NULL, -- Notas adicionales
    seated_at timestamp NULL, -- Fecha y hora cuando fue sentado
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: reviews
-- Almacena las reseñas y valoraciones dejadas por los clientes.
-- Permite recoger feedback sobre la experiencia y mejorar el servicio.
-- Las reseñas pueden asociarse a visitas específicas o ser generales.
-- --------------------------------------------------------
CREATE TABLE reviews (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id bigint UNSIGNED NULL, -- ID del cliente que deja la reseña
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante reseñado
    reservation_id bigint UNSIGNED NULL, -- ID de la reserva relacionada (si aplica)
    visit_id bigint UNSIGNED NULL, -- ID de la visita relacionada (si aplica)
    rating int NOT NULL, -- Valoración general (1-5)
    food_rating int NULL, -- Valoración de la comida (1-5)
    service_rating int NULL, -- Valoración del servicio (1-5)
    ambiance_rating int NULL, -- Valoración del ambiente (1-5)
    value_rating int NULL, -- Valoración de la relación calidad-precio (1-5)
    comments text NULL, -- Comentarios detallados del cliente
    is_public tinyint(1) NOT NULL DEFAULT 1, -- Si la reseña es pública (1) o privada (0)
    is_verified tinyint(1) NOT NULL DEFAULT 0, -- Si se ha verificado que el cliente visitó
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE SET NULL,
    FOREIGN KEY (visit_id) REFERENCES customer_visits(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: restaurant_settings (continuación)
-- Almacena configuraciones específicas de cada restaurante que
-- no encajan en la tabla principal de restaurantes. Permite personalizar
-- el funcionamiento del sistema según las necesidades de cada establecimiento.
-- --------------------------------------------------------
CREATE TABLE restaurant_settings (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante al que pertenece esta configuración
    setting_key varchar(100) NOT NULL, -- Nombre de la configuración (ej: "advance_booking_days")
    setting_value text NULL, -- Valor de la configuración
    description text NULL, -- Descripción de para qué sirve esta configuración
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: staff_members
-- Registra al personal del restaurante y sus roles.
-- Permite asignar permisos y responsabilidades específicas a cada miembro
-- del equipo, así como controlar turnos y disponibilidad.
-- --------------------------------------------------------
CREATE TABLE staff_members (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante donde trabaja
    user_id bigint UNSIGNED NULL, -- ID del usuario del sistema (si tiene acceso)
    name varchar(255) NOT NULL, -- Nombre completo del miembro del personal
    email varchar(255) NULL, -- Correo electrónico
    phone varchar(255) NULL, -- Teléfono de contacto
    position varchar(100) NOT NULL, -- Puesto (ej: "Maître", "Camarero", "Chef")
    hire_date date NULL, -- Fecha de contratación
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado (1=activo, 0=inactivo)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: staff_schedules
-- Gestiona los horarios y turnos del personal del restaurante.
-- Permite organizar la cobertura del personal según las necesidades
-- operativas y prever ausencias o vacaciones.
-- --------------------------------------------------------
CREATE TABLE staff_schedules (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    staff_id bigint UNSIGNED NOT NULL, -- ID del miembro del personal
    schedule_date date NOT NULL, -- Fecha del turno
    start_time time NOT NULL, -- Hora de inicio del turno
    end_time time NOT NULL, -- Hora de fin del turno
    break_duration int NULL, -- Duración del descanso en minutos
    status varchar(50) NOT NULL DEFAULT 'scheduled', -- Estado: 'scheduled', 'completed', 'absent', 'cancelled'
    notes text NULL, -- Notas sobre el turno
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (staff_id) REFERENCES staff_members(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: reservation_logs
-- Registra un historial de cambios en las reservas.
-- Permite seguir la evolución de cada reserva y quién realizó cada cambio,
-- útil para auditoría y resolución de incidencias.
-- --------------------------------------------------------
CREATE TABLE reservation_logs (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    reservation_id bigint UNSIGNED NOT NULL, -- ID de la reserva afectada
    staff_id bigint UNSIGNED NULL, -- ID del miembro del personal que realizó el cambio
    action varchar(50) NOT NULL, -- Acción realizada: 'created', 'modified', 'cancelled', 'confirmed'
    old_status varchar(50) NULL, -- Estado anterior de la reserva
    new_status varchar(50) NULL, -- Nuevo estado de la reserva
    notes text NULL, -- Notas sobre el cambio realizado
    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora del cambio
    PRIMARY KEY (id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff_members(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: payment_methods
-- Define los métodos de pago aceptados en cada restaurante.
-- Permite configurar qué opciones de pago están disponibles para
-- los clientes, tanto online como en el establecimiento.
-- --------------------------------------------------------
CREATE TABLE payment_methods (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante
    name varchar(100) NOT NULL, -- Nombre del método de pago (ej: "Tarjeta de crédito", "PayPal")
    type varchar(50) NOT NULL, -- Tipo: 'card', 'cash', 'online', 'cryptocurrency'
    is_online tinyint(1) NOT NULL DEFAULT 0, -- Si se puede usar para pagos online (1=sí, 0=no)
    is_onsite tinyint(1) NOT NULL DEFAULT 0, -- Si se puede usar en el restaurante (1=sí, 0=no)
    commission_rate decimal(5,2) NULL, -- Comisión aplicada por este método de pago
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado (1=activo, 0=inactivo)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: payments
-- Registra los pagos realizados por los clientes.
-- Puede incluir pagos por adelantado para reservas, depósitos o
-- pagos completos de consumiciones durante la visita.
-- --------------------------------------------------------
CREATE TABLE payments (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    reservation_id bigint UNSIGNED NULL, -- ID de la reserva relacionada (si aplica)
    visit_id bigint UNSIGNED NULL, -- ID de la visita relacionada (si aplica)
    customer_id bigint UNSIGNED NULL, -- ID del cliente que realiza el pago
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante
    payment_method_id bigint UNSIGNED NOT NULL, -- ID del método de pago utilizado
    amount decimal(10,2) NOT NULL, -- Importe del pago
    payment_type varchar(50) NOT NULL, -- Tipo: 'deposit', 'full_payment', 'partial_payment'
    status varchar(50) NOT NULL DEFAULT 'pending', -- Estado: 'pending', 'completed', 'failed', 'refunded'
    transaction_id varchar(255) NULL, -- ID de la transacción del procesador de pagos
    notes text NULL, -- Notas sobre el pago
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE SET NULL,
    FOREIGN KEY (visit_id) REFERENCES customer_visits(id) ON DELETE SET NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: loyalty_programs
-- Define los programas de fidelización disponibles en cada restaurante.
-- Permite configurar sistemas de puntos, recompensas y beneficios
-- para clientes frecuentes.
-- --------------------------------------------------------
CREATE TABLE loyalty_programs (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id bigint UNSIGNED NOT NULL, -- ID del restaurante
    name varchar(255) NOT NULL, -- Nombre del programa de fidelización
    description text NULL, -- Descripción del programa
    points_per_currency decimal(5,2) NOT NULL, -- Puntos obtenidos por unidad monetaria gastada
    currency_per_points decimal(5,2) NOT NULL, -- Valor en moneda de cada punto
    min_points_to_redeem int NOT NULL, -- Mínimo de puntos necesarios para canjear
    is_active tinyint(1) NOT NULL DEFAULT 1, -- Estado (1=activo, 0=inactivo)
    created_at timestamp NULL DEFAULT NULL, -- Fecha y hora de creación del registro
    updated_at timestamp NULL DEFAULT NULL, -- Fecha y hora de última actualización
    PRIMARY KEY (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: customer_loyalty
-- Registra la participación de los clientes en los programas de fidelización.
-- Controla el saldo de puntos de cada cliente y su historial de canjes.
-- --------------------------------------------------------
CREATE TABLE customer_loyalty (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT,