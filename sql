-- Script de Criação de Banco de Dados para E-commerce

-- Criação da tabela de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL,
    cpf VARCHAR(11) UNIQUE,
    cnpj VARCHAR(14) UNIQUE,
    CHECK (tipo_cliente = 'PF' AND cpf IS NOT NULL OR tipo_cliente = 'PJ' AND cnpj IS NOT NULL)
);

-- Criação da tabela de fornecedores
CREATE TABLE fornecedores (
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    nome_fornecedor VARCHAR(100) NOT NULL,
    contato VARCHAR(50)
);

-- Criação da tabela de produtos
CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    quantidade_estoque INT NOT NULL,
    id_fornecedor INT,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id_fornecedor)
);

-- Criação da tabela de pedidos
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Criação da tabela de pagamentos
CREATE TABLE pagamentos (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    forma_pagamento ENUM('Cartão', 'Boleto', 'Pix', 'Transferência') NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- Criação da tabela de entregas
CREATE TABLE entregas (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    status_entrega ENUM('Pendente', 'Em Transporte', 'Entregue') NOT NULL,
    codigo_rastreamento VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- Inserção de dados nas tabelas
INSERT INTO clientes (nome, tipo_cliente, cpf) VALUES ('João Silva', 'PF', '12345678901');
INSERT INTO clientes (nome, tipo_cliente, cnpj) VALUES ('Empresa ABC', 'PJ', '12345678000199');

INSERT INTO fornecedores (nome_fornecedor, contato) VALUES ('Fornecedor XYZ', 'xyz@fornecedor.com');

INSERT INTO produtos (nome_produto, preco, quantidade_estoque, id_fornecedor) 
VALUES ('Produto A', 50.00, 100, 1);

INSERT INTO pedidos (id_cliente, data_pedido, valor_total) 
VALUES (1, '2024-12-01', 150.00);

INSERT INTO pagamentos (id_pedido, forma_pagamento) VALUES (1, 'Cartão');

INSERT INTO entregas (id_pedido, status_entrega, codigo_rastreamento) 
VALUES (1, 'Em Transporte', 'ABC12345678');

-- Consultas SQL

-- Quantos pedidos foram feitos por cada cliente?
SELECT c.nome, COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.nome;

-- Algum fornecedor também é vendedor?
SELECT NULL; -- Para implementar caso haja tabela de vendedores.

-- Produtos, fornecedores e estoque
SELECT p.nome_produto, f.nome_fornecedor, p.quantidade_estoque
FROM produtos p
JOIN fornecedores f ON p.id_fornecedor = f.id_fornecedor;
