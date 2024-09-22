# todo
## run backend
first go to the backend dir then run:

```
composer install
cp cp .env.example .env
```

Generate the application key:

```
php artisan key:generate
```

then migrate:

```
php artisan migrate
```

Run the development server:

```
php artisan server
```
