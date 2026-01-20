-- ================================================================
-- SISTEMA DE RESERVAS PARA RESTAURANTES
-- Compatible con Laravel 11 + Filament v4
-- Diseño optimizado para multi-restaurante y escalabilidad
-- ================================================================

-- --------------------------------------------------------
-- Tabla: restaurants
-- Representa cada restaurante en la plataforma
-- --------------------------------------------------------
CREATE TABLE restaurants (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id bigint UNSIGNED NOT NULL,          -- Usuario propietario (dueño)
  name varchar(255) NOT NULL,                -- Nombre del restaurante
  slug varchar(255) NOT NULL UNIQUE,         -- URL amigable (ej: /restaurantes/la-trattoria)
  description text NULL,                     -- Descripción pública
  address varchar(255) NULL,                 -- Dirección física
  city varchar(255) NULL,                    -- Ciudad
  phone varchar(255) NULL,                   -- Teléfono de contacto
  email varchar(255) NULL,                   -- Email público
  open_time time NOT NULL,                   -- Hora de apertura
  close_time time NOT NULL,                  -- Hora de cierre
  default_reservation_duration int NOT NULL DEFAULT 90,  -- Duración típica de reserva (minutos)
  cleanup_buffer_minutes int NOT NULL DEFAULT 15,        -- Tiempo de limpieza entre reservas
  accepts_walk_ins tinyint(1) NOT NULL DEFAULT 1,       -- ¿Acepta clientes sin reserva?
  is_active tinyint(1) NOT NULL DEFAULT 1,              -- ¿Está activo en la plataforma?
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: restaurant_areas
-- Áreas/zonas dentro de cada restaurante (Terraza, Salón, Bar, etc.)
-- Cada restaurante define sus propias áreas
-- --------------------------------------------------------
CREATE TABLE restaurant_areas (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  restaurant_id bigint UNSIGNED NOT NULL,    -- Restaurante al que pertenece
  name varchar(255) NOT NULL,                -- Nombre del área (ej: "Terraza", "Salón VIP")
  description text NULL,                     -- Descripción opcional
  status tinyint(1) NOT NULL DEFAULT 1,      -- 1 = activo, 0 = inactivo
  sort_order int DEFAULT 0,                  -- Orden de visualización
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: tables
-- Mesas dentro de cada restaurante
-- Cada mesa pertenece a UNA sola área (diseño realista y simple)
-- --------------------------------------------------------
CREATE TABLE tables (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  restaurant_id bigint UNSIGNED NOT NULL,    -- Restaurante al que pertenece
  area_id bigint UNSIGNED NULL,              -- Área a la que pertenece (puede ser NULL)
  name varchar(255) NOT NULL,                -- Nombre/número de la mesa (ej: "Mesa 5", "VIP-1")
  capacity int NOT NULL,                     -- Capacidad máxima de personas
  min_capacity int NULL,                     -- Capacidad mínima recomendada (opcional)
  status varchar(255) NOT NULL DEFAULT 'available',  -- 'available', 'maintenance', 'blocked'
  is_active tinyint(1) NOT NULL DEFAULT 1,   -- ¿Está disponible para reservas?
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
  FOREIGN KEY (area_id) REFERENCES restaurant_areas(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: type_event
-- Tipos de eventos/reservas especiales
-- Usado para clasificar reservas (cumpleaños, boda, etc.)
-- --------------------------------------------------------
CREATE TABLE type_event (
  id_type bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,                -- Nombre del tipo (ej: "Cumpleaños", "Boda")
  description text NULL,                     -- Descripción opcional
  configure_special tinyint(1) DEFAULT 0,    -- ¿Requiere configuración especial? (0=no, 1=sí)
  status tinyint(1) DEFAULT 1,               -- 1 = activo, 0 = inactivo
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: reservations
-- Reservas realizadas por clientes
-- No contiene relación directa con mesas (usa tabla pivote)
-- --------------------------------------------------------
CREATE TABLE reservations (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  restaurant_id bigint UNSIGNED NOT NULL,    -- Restaurante reservado
  event_type_id bigint UNSIGNED NULL,        -- Tipo de evento (NULL = reserva regular)
  codigo varchar(10) NOT NULL UNIQUE,        -- Código único de reserva (ej: RV-0001)
  customer_name varchar(255) NOT NULL,       -- Nombre del cliente
  customer_email varchar(255) NULL,          -- Email del cliente (opcional)
  customer_phone varchar(255) NOT NULL,      -- Teléfono del cliente
  party_size int NOT NULL,                   -- Número de personas
  date date NOT NULL,                        -- Fecha de la reserva
  start_time time NULL,                      -- Hora de inicio
  end_time time NULL,                        -- Hora de fin (calculada o definida)
  duration int NULL,                         -- Duración en minutos
  status varchar(255) NOT NULL DEFAULT 'pending',  -- 'pending', 'confirmed', 'cancelled', 'completed'
  notes text NULL,                           -- Notas adicionales del cliente
  source varchar(20) NULL DEFAULT 'web',     -- Origen: 'web', 'phone', 'walk-in', 'api'
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
  FOREIGN KEY (event_type_id) REFERENCES type_event(id_type) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: reservation_tables
-- Relación MUCHOS A MUCHOS entre reservas y mesas
-- Permite asignar múltiples mesas a una sola reserva
-- --------------------------------------------------------
CREATE TABLE reservation_tables (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  reservation_id bigint UNSIGNED NOT NULL,   -- Reserva
  table_id bigint UNSIGNED NOT NULL,         -- Mesa asignada
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_reservation_table (reservation_id, table_id),  -- Evita duplicados
  FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
  FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menus
-- Menús de cada restaurante
-- Un restaurante puede tener varios menús (ej: menú de día, menú ejecutivo)
-- --------------------------------------------------------
CREATE TABLE menus (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  restaurant_id bigint UNSIGNED NOT NULL,    -- Restaurante al que pertenece
  name varchar(255) NOT NULL DEFAULT 'Carta principal',
  is_active tinyint(1) NOT NULL DEFAULT 1,   -- ¿Está visible?
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_categories
-- Categorías dentro de un menú (Entradas, Platos fuertes, Postres, etc.)
-- --------------------------------------------------------
CREATE TABLE menu_categories (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  menu_id bigint UNSIGNED NOT NULL,          -- Menú al que pertenece
  name varchar(255) NOT NULL,                -- Nombre de la categoría
  description text NULL,                     -- Descripción opcional
  sort_order int NOT NULL DEFAULT 0,         -- Orden de visualización
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_items
-- Ítems/platos dentro de una categoría
-- --------------------------------------------------------
CREATE TABLE menu_items (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  category_id bigint UNSIGNED NOT NULL,      -- Categoría a la que pertenece
  name varchar(255) NOT NULL,                -- Nombre del plato
  description text NULL,                     -- Descripción/ingredientes
  price decimal(8,2) NOT NULL,               -- Precio base
  image_path varchar(255) NULL,              -- Ruta de la imagen
  is_available tinyint(1) NOT NULL DEFAULT 1,-- ¿Está disponible hoy?
  prep_time_minutes int NULL,                -- Tiempo estimado de preparación
  allergens varchar(255) NULL,               -- Alérgenos (ej: "gluten,lactosa")
  sort_order int NOT NULL DEFAULT 0,         -- Orden dentro de la categoría
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (category_id) REFERENCES menu_categories(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_item_options
-- Opciones de personalización para un ítem (tamaño, extras, etc.)
-- --------------------------------------------------------
CREATE TABLE menu_item_options (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  item_id bigint UNSIGNED NOT NULL,          -- Ítem al que pertenece
  name varchar(255) NOT NULL,                -- Nombre de la opción (ej: "Tamaño", "Extras")
  is_required tinyint(1) NOT NULL DEFAULT 0, -- ¿Es obligatoria?
  allow_multiple tinyint(1) NOT NULL DEFAULT 0, -- ¿Permite múltiples selecciones?
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (item_id) REFERENCES menu_items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_item_option_values
-- Valores específicos dentro de una opción
-- --------------------------------------------------------
CREATE TABLE menu_item_option_values (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  option_id bigint UNSIGNED NOT NULL,        -- Opción a la que pertenece
  label varchar(255) NOT NULL,               -- Etiqueta visible (ej: "Grande", "Queso extra")
  price_adjustment decimal(8,2) NOT NULL DEFAULT 0.00, -- Ajuste de precio (+2.50)
  is_default tinyint(1) NOT NULL DEFAULT 0,  -- ¿Es el valor predeterminado?
  stock int NULL,                            -- Stock disponible (NULL = ilimitado)
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (option_id) REFERENCES menu_item_options(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: promotions
-- Promociones/anuncios programados por fecha
-- --------------------------------------------------------
CREATE TABLE promotions (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  restaurant_id bigint UNSIGNED NOT NULL,    -- Restaurante al que pertenece
  title varchar(255) NOT NULL,               -- Título de la promoción
  description text NOT NULL,                 -- Descripción detallada
  image_path varchar(255) NULL,              -- Imagen opcional
  start_date date NOT NULL,                  -- Fecha de inicio
  end_date date NOT NULL,                    -- Fecha de fin
  is_active tinyint(1) NOT NULL DEFAULT 1,   -- ¿Está activa?
  promotion_type varchar(255) NOT NULL,      -- 'menu', 'discount', 'event', 'announcement'
  target_url varchar(255) NULL,              -- URL de destino (opcional)
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- ÍNDICES PARA RENDIMIENTO
-- Optimizados para consultas frecuentes
-- --------------------------------------------------------
CREATE INDEX idx_reservations_date_status ON reservations (date, status);
CREATE INDEX idx_reservations_restaurant_date ON reservations (restaurant_id, date);
CREATE INDEX idx_tables_restaurant_status ON tables (restaurant_id, status, is_active);
CREATE INDEX idx_promotions_restaurant_dates ON promotions (restaurant_id, start_date, end_date);
CREATE INDEX idx_tables_area ON tables (area_id);
CREATE INDEX idx_reservation_tables_reservation ON reservation_tables (reservation_id);