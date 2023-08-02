-- Criação do Database da Oficina.
CREATE DATABASE IF NOT EXISTS oficina;
USE oficina;


-- Criação das Tabelas da Oficina.
CREATE TABLE funcionario(
	idFuncionario INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Sobrenome VARCHAR(45) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Telefone CHAR(11) NOT NULL,
    Cargo ENUM('Mecanico','Gerente','Faxineiro') DEFAULT('Mecanico'),
    Salario INT,
    CONSTRAINT unique_funcionario_cpf UNIQUE(CPF)    
    );

CREATE TABLE cliente(
	idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Sobrenome VARCHAR(45) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Telefone CHAR(11),
    CONSTRAINT unique_cliente_cpf UNIQUE(CPF)
	);

CREATE TABLE veiculo(
	idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    Placa VARCHAR(45) NOT NULL,
    Tipo ENUM('Carro','Moto') DEFAULT('Carro'),
    Marca VARCHAR(45) NOT NULL,
    Modelo VARCHAR(45) NOT NULL,
    CONSTRAINT fk_veiculo_idcliente FOREIGN KEY(idCliente) REFERENCES cliente(idCliente),
    CONSTRAINT unique_veiculo_placa UNIQUE(Placa)
    );

CREATE TABLE forma_pagamento(
	idFormaPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    TIPO ENUM('Cartao Debito','Cartao Credito','PIX', 'Dinheiro'),
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY(idCliente) REFERENCES cliente(idCliente)
	);

CREATE TABLE produto(
	idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nomeProduto VARCHAR(45) NOT NULL,
    Preco INT NOT NULL
    );

CREATE TABLE servico(
	idServico INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    idFuncionario INT NOT NULL,
    idPagamento INT NOT NULL,
    idVeiculo INT NOT NULL,
    Descricao VARCHAR(45) NOT NULL,
    Valor INT NOT NULL,
    dataServico DATE,
    prazoServico DATE,
    statusServico ENUM('Aguardando', 'Em andamento', 'Finalizado', 'Cancelado') DEFAULT('Aguardando'),
    CONSTRAINT fk_servico_cliente FOREIGN KEY(idCliente) REFERENCES cliente(idCliente),
    CONSTRAINT fk_servico_funcionario FOREIGN KEY(idFuncionario) REFERENCES funcionario(idFuncionario),
    CONSTRAINT fk_servico_pagamento FOREIGN KEY(idPagamento) REFERENCES forma_pagamento(idFormaPagamento),
    CONSTRAINT fk_servico_veiculo FOREIGN KEY(idVeiculo) REFERENCES veiculo(idVeiculo)
    );

CREATE TABLE produto_servico(
	idProduto INT NOT NULL,
    idServico INT NOT NULL,
    Quantidade INT NOT NULL,
    CONSTRAINT pk_produto_servico PRIMARY KEY(idProduto, idServico),
    CONSTRAINT fk_produto_servico_prod FOREIGN KEY(idProduto) REFERENCES produto(idProduto),
    CONSTRAINT fk_produto_servico_serv FOREIGN KEY(idServico) REFERENCES servico(idServico)
	);
    
SHOW TABLES;

-- Inserção de valores nas tabelas para teste.
INSERT INTO funcionario(Nome,Sobrenome,CPF,Telefone,Cargo,Salario) VALUES('Jonathan','Wallace','78945612385','11987458745','Gerente',4500.00),
																		('Vinicius','Soares','45685217935','11925632563','Mecanico',2200.00),
																		('Gabriele','Almeida','25874136945','11958965896','Mecanico',2200.00),
                                                                        ('Milena','Tota','54123698745','11954125425','Faxineiro',1800.00);

INSERT INTO cliente(Nome,Sobrenome,CPF,Telefone) VALUES('Julia','Mitiko','4528976451','11954862798'),
													   ('Rony','Chow','45847943257','11945632178');
                                                       
INSERT INTO forma_pagamento(idCliente,Tipo) VALUES('1','Cartao Debito'),
												  ('2','Cartao Credito');
                                                  
INSERT INTO veiculo(idCliente,Placa,Tipo,Marca,Modelo)VALUES('1','JAP-4545','Carro','Fiat','101'),
														    ('2','CHN-7895','Moto','Yamaha','205');

INSERT INTO produto(nomeProduto,Preco) VALUES('Pneu',250.00),
									         ('Motor',5000.00);

INSERT INTO servico(idFuncionario,idCliente,idPagamento,idVeiculo,Descricao,Valor,dataServico,prazoServico,statusServico) VALUES('2','2','2','2','Troca do Pneu',450.00,'2023-08-02','2023-08-22','Aguardando'),
                                                                                                                                ('3','1','1','1','Troca do Motor',5250.00,'2023-08-02','2023-08-28','Em andamento');

INSERT INTO produto_servico(idProduto,idServico,Quantidade) VALUES('1','1',1),
																  ('2','2',1);

-- Realizando Query teste.

-- Relação de serviços realizados ordenados por prazo.
SELECT * FROM servico
	ORDER BY prazoServico;

-- Relação de serviços realizados com o nome do funcionario, descrição do serviço, nome do cliente, valor e prazo.
SELECT f.Nome AS Funcionario, s.Descricao AS Servico, CONCAT(v.Tipo,' ',v.Placa) AS Veiculo, c.Nome AS Cliente, ROUND(s.Valor,2) AS Valor_do_Servico, s.prazoServico AS Prazo
	FROM funcionario f, servico s, veiculo v, cliente c
    WHERE s.idFuncionario = f.idFuncionario AND s.idVeiculo = v.idVeiculo AND s.idCliente = c.idCliente;

-- Relação dos cargos com mais de um funcionário.
SELECT Cargo, COUNT(*) AS Funcionarios FROM funcionario
	GROUP BY Cargo
    HAVING Funcionarios > 1;

