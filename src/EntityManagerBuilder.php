<?php

namespace App;

use Doctrine\ORM\EntityManager;
use Doctrine\ORM\ORMSetup;
use Symfony\Component\Dotenv\Dotenv;

class EntityManagerBuilder
{
    private EntityManager $entityManager;

    public function __construct()
    {
        $this->entityManager = $this->createManager();
    }

    private function createManager(): EntityManager
    {
        $config = ORMSetup::createAnnotationMetadataConfiguration([__DIR__], true, null, null);

        // database configuration parameters
        $conn = [
            'driver' => 'pdo_mysql',
            'url' => $this->getDatabaseUrl(),
        ];

        // obtaining the entity manager
        return EntityManager::create($conn, $config);
    }

    private function getDatabaseUrl(): string
    {
        $dotenv = new Dotenv();
        $dotenv->load(__DIR__.'/../.env.test');

        return sprintf('mysql://%s:%s@%s:3306/%s?serverVersion=5.7', $_ENV['MYSQL_USER'], $_ENV['MYSQL_PASSWORD'], $_ENV['MYSQL_HOST'], $_ENV['MYSQL_DATABASE']);
    }

    public function getEntityManager(): EntityManager
    {
        return $this->entityManager;
    }
}
