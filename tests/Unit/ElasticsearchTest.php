<?php

namespace App\Tests;

use PHPUnit\Framework\TestCase;
use Symfony\Component\Dotenv\Dotenv;
use Symfony\Component\HttpClient\HttpClient;

class ElasticsearchTest extends TestCase
{
    public function testConnection()
    {
        $client = HttpClient::create();
        $response = $client->request('GET', $this->getElasticsearchHost());

        $this->assertSame(200, $response->getStatusCode());
        $this->assertArrayHasKey('tagline', json_decode($response->getContent(), true));
    }

    private function getElasticsearchHost(): string
    {
        $dotenv = new Dotenv();
        $dotenv->load(__DIR__.'/../../.env.test');

        return $_ENV['ELASTICSEARCH_HOST'];
    }
}
