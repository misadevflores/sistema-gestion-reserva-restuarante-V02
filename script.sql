-- SCRIPT MAS LIEMPIO Y ORGANIZADO DE BASE DE DATOS PARA SISTEMA DE RESERVAS DE RESTAURANTES 
-- --------------------------------------------------------
-- Tabla: restaurants
-- --------------------------------------------------------
CREATE TABLE restaurants (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id bigint UNSIGNED NOT NULL, -- propietario del restaurante
  name varchar(255) NOT NULL, --    nombre del restaurante
  slug varchar(255) NOT NULL UNIQUE, -- para URL amigables
  description text NULL,  -- descrion del restuarante
  address varchar(255) NOT NULL, -- direccion del restaurante
  city varchar(255) NULL, --    ciudad del restaurante
  phone varchar(255) NULL, -- telefono del restaurante
  email varchar(255) NULL, -- correo del restaurante
  open_time time NOT NULL,  -- horario de apertura
  close_time time NOT NULL, -- horario de cierre 
  default_reservation_duration int NOT NULL DEFAULT '90', -- duración por defecto de la reserva
  cleanup_buffer_minutes int NOT NULL DEFAULT '15', -- tiempo de limpieza entre reservas
  accepts_walk_ins tinyint(1) NOT NULL DEFAULT '1', -- acepta clientes sin reserva
  is_active tinyint(1) NOT NULL DEFAULT '1', -- estado del restaurante
  created_at timestamp NULL DEFAULT NULL, --    fecha de creación
  updated_at timestamp NULL DEFAULT NULL, -- fecha de actualización
  PRIMARY KEY (id), --  clave primaria
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE -- clave foránea al usuario propietario
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: tables (mesas)
-- --------------------------------------------------------
CREATE TABLE tables (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT, -- id de la mesa
  restaurant_id bigint UNSIGNED NOT NULL, -- id de34l restaurante
  name varchar(255) NOT NULL, -- nombre o número de la mesa
  capacity int NOT NULL, -- capacidad máxima de la mesa
  min_capacity int NULL, -- capacidad mínima de la mesa
  location varchar(255) NOT NULL, -- 'indoor', 'outdoor', 'bar' -- ubicación de la mesa
  status varchar(255) NOT NULL DEFAULT 'available', -- 'available', 'maintenance', 'blocked' -- estado de la mesa
  is_active tinyint(1) NOT NULL DEFAULT '1', -- estado de la mesa
  created_at timestamp NULL DEFAULT NULL,  -- fecha de creación
  updated_at timestamp NULL DEFAULT NULL,  -- fecha de actualización
  PRIMARY KEY (id), -- clave primaria
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: reservations
-- --------------------------------------------------------
CREATE TABLE reservations (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,  -- id de la reserva
  restaurant_id bigint UNSIGNED NOT NULL, -- id del restaurante
  table_id bigint UNSIGNED NULL,  -- id de la mesa (puede ser NULL si no se asigna)
  customer_name varchar(255) NOT NULL,  -- nombre del cliente
  customer_email varchar(255) NOT NULL, -- correo del cliente
  customer_phone varchar(255) NOT NULL,  -- telefono del cliente
  party_size int NOT NULL,  -- número de personas
  date date NOT NULL, --    fecha de la reserva
  start_time time NOT NULL, -- hora de inicio de la reserva
  end_time time NOT NULL, -- hora de fin de la reserva
  duration int NOT NULL,  -- duración en minutos
  status varchar(255) NOT NULL DEFAULT 'pending', -- 'pending', 'confirmed', 'cancelled', 'completed' -- estado de la reserva
  notes text NULL, -- notas adicionales
  reservation_type varchar(255) NOT NULL DEFAULT 'regular', -- 'regular', 'birthday', 'wedding', 'graduation', 'corporate', 'other' -- tipo de reserva
  created_at timestamp NULL DEFAULT NULL, -- fecha de creación
  updated_at timestamp NULL DEFAULT NULL, -- fecha de actualización
  PRIMARY KEY (id), -- clave primaria
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE, -- clave foránea al restaurante 
  FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menus
-- --------------------------------------------------------
CREATE TABLE menus (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  restaurant_id bigint UNSIGNED NOT NULL, -- id del restaurante
  name varchar(255) NOT NULL DEFAULT 'Carta principal', -- nombre del menú
  is_active tinyint(1) NOT NULL DEFAULT '1', -- estado del menú
  created_at timestamp NULL DEFAULT NULL, -- fecha de creación
  updated_at timestamp NULL DEFAULT NULL, -- fecha de actualización
  PRIMARY KEY (id), -- clave primaria
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE -- clave foránea al restaurante
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_categories
-- --------------------------------------------------------
CREATE TABLE menu_categories (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT, -- id de la categoría
  menu_id bigint UNSIGNED NOT NULL, -- id del menú
  name varchar(255) NOT NULL, -- nombre de la categoría
  description text NULL, -- descripción de la categoría
  sort_order int NOT NULL DEFAULT '0', -- orden de clasificación
  created_at timestamp NULL DEFAULT NULL, -- fecha de creación
  updated_at timestamp NULL DEFAULT NULL, -- fecha de actualización
  PRIMARY KEY (id), -- clave primaria
  FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE -- clave foránea al menú
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_items
-- --------------------------------------------------------
CREATE TABLE menu_items (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT, -- id del ítem
  category_id bigint UNSIGNED NOT NULL, -- id de la categoría
  name varchar(255) NOT NULL, -- nombre del ítem
  description text NULL, -- descripción del ítem
  price decimal(8,2) NOT NULL, -- precio del ítem
  image_path varchar(255) NULL, -- ruta de la imagen del ítem
  is_available tinyint(1) NOT NULL DEFAULT '1', -- disponibilidad del ítem
  prep_time_minutes int NULL, --    tiempo de preparación en minutos
  allergens varchar(255) NULL, -- ej: "gluten,lactosa" -- alérgenos del ítem
  sort_order int NOT NULL DEFAULT '0', -- orden de clasificación
  created_at timestamp NULL DEFAULT NULL, -- fecha de creación
  updated_at timestamp NULL DEFAULT NULL,  -- fecha de actualización
  PRIMARY KEY (id), -- clave primaria   
  FOREIGN KEY (category_id) REFERENCES menu_categories(id) ON DELETE CASCADE -- clave foránea a la categoría
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_item_options
-- --------------------------------------------------------
CREATE TABLE menu_item_options (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT, --    id de la opción
  item_id bigint UNSIGNED NOT NULL, -- id del ítem
  name varchar(255) NOT NULL, -- nombre de la opción
  is_required tinyint(1) NOT NULL DEFAULT '0', -- si es obligatorio seleccionar esta opción
  allow_multiple tinyint(1) NOT NULL DEFAULT '0', -- si se permiten múltiples selecciones
  created_at timestamp NULL DEFAULT NULL, -- fecha de creación
  updated_at timestamp NULL DEFAULT NULL, -- fecha de actualización
  PRIMARY KEY (id), -- clave primaria
  FOREIGN KEY (item_id) REFERENCES menu_items(id) ON DELETE CASCADE .-- clave foránea al ítem
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: menu_item_option_values
-- --------------------------------------------------------
CREATE TABLE menu_item_option_values (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT, --- id del valor de la opción
  option_id bigint UNSIGNED NOT NULL, -- id de la opción
  label varchar(255) NOT NULL, -- etiqueta del valor
  price_adjustment decimal(8,2) NOT NULL DEFAULT '0.00', -- ajuste de precio
  is_default tinyint(1) NOT NULL DEFAULT '0', -- si es el valor por defecto
  stock int NULL, -- stock disponible (NULL si es ilimitado)
  created_at timestamp NULL DEFAULT NULL, -- fecha de creación
  updated_at timestamp NULL DEFAULT NULL, -- fecha de actualización
  PRIMARY KEY (id), -- clave primaria
  FOREIGN KEY (option_id) REFERENCES menu_item_options(id) ON DELETE CASCADE -- clave foránea a la opción
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabla: promotions (anuncios/promociones programadas)
-- --------------------------------------------------------
CREATE TABLE promotions (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT, -- id de la promoción
  restaurant_id bigint UNSIGNED NOT NULL, -- id del restaurante
  title varchar(255) NOT NULL, -- título de la promoción
  description text NOT NULL, -- descripción de la promoción
  image_path varchar(255) NULL, -- ruta de la imagen de la promoción
  start_date date NOT NULL, -- fecha de inicio
  end_date date NOT NULL, -- fecha de fin
  is_active tinyint(1) NOT NULL DEFAULT '1', -- si está activa
  promotion_type varchar(255) NOT NULL, -- 'menu', 'discount', 'event', 'announcement' -- tipo de promoción
  target_url varchar(255) NULL, -- URL de destino al hacer clic
  created_at timestamp NULL DEFAULT NULL, -- fecha de creación
  updated_at timestamp NULL DEFAULT NULL, -- fecha de actualización
  PRIMARY KEY (id), -- clave primaria
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE -- clave foránea al restaurante
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Índices para rendimiento
-- --------------------------------------------------------
CREATE INDEX reservations_date_status_index ON reservations (date, status); -- índice para consultas frecuentes por fecha y estado
CREATE INDEX reservations_restaurant_date_index ON reservations (restaurant_id, date);  -- índice para consultas por restaurante y fecha
CREATE INDEX tables_restaurant_status_index ON tables (restaurant_id, status, is_active); -- índice para consultas de mesas por restaurante y estado
CREATE INDEX promotions_restaurant_dates_index ON promotions (restaurant_id, start_date, end_date); -- índice para promociones activas por restaurante y fechas