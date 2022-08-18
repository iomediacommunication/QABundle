<?php

namespace App\Tests;

use App\EntityManagerBuilder;
use PHPUnit\Framework\TestCase;

class ProductTest extends TestCase
{
    public function testRetrieveFromDatabase()
    {
        $em = (new EntityManagerBuilder())->getEntityManager();

        $products = $em->getRepository('App\Entity\Product')->findBy([]);
        $this->assertSame(10, count($products));
    }
}
