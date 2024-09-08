-- Criar o banco de dados se não existir
CREATE DATABASE IF NOT EXISTS azure_company;

-- Usar o banco de dados
USE azure_company;

-- Verificar se há tabelas no banco de dados
SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'azure_company';

-- Criar a tabela Employee
CREATE TABLE employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR(1),
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL, 
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL DEFAULT 1,
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.0),
    CONSTRAINT pk_employee PRIMARY KEY (Ssn)
);

-- Adicionar a chave estrangeira
ALTER TABLE employee 
ADD CONSTRAINT fk_employee 
FOREIGN KEY (Super_ssn) REFERENCES employee(Ssn)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- Visualizar a estrutura da tabela Employee
DESC employee;


-- Criar a tabela departament
CREATE TABLE departament (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE, 
    Dept_create_date DATE,
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE (Dname),
    FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
);

-- Se precisar remover uma constraint existente, certifique-se do nome correto. 
-- Aqui, 'departament_ibfk_1' é um exemplo e pode não ser o nome real.

-- ALTER TABLE para remover e adicionar a chave estrangeira
ALTER TABLE departament DROP FOREIGN KEY departament_ibfk_1;

ALTER TABLE departament 
    ADD CONSTRAINT fk_dept FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
    ON UPDATE CASCADE;

-- Exibir a estrutura da tabela departament
DESC departament;


-- Criar a tabela dept_locations
CREATE TABLE dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES departament (Dnumber)
);

-- Remover a constraint se necessário (verifique o nome correto)
ALTER TABLE dept_locations DROP FOREIGN KEY fk_dept_locations;

-- Adicionar a constraint com as opções desejadas
ALTER TABLE dept_locations 
ADD CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES departament(Dnumber)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Verificar a estrutura da tabela
DESC dept_locations;


-- Criar a tabela project
CREATE TABLE project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname),
    CONSTRAINT fk_project FOREIGN KEY (Dnum) REFERENCES departament(Dnumber)
);

-- Criar a tabela works_on
CREATE TABLE works_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL,
    PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_employee_works_on FOREIGN KEY (Essn) REFERENCES employee(Ssn),
    CONSTRAINT fk_project_works_on FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);

-- Remover a tabela dependent se existir
DROP TABLE IF EXISTS dependent;

-- Criar a tabela dependent
CREATE TABLE dependent (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);

-- Mostrar tabelas
SHOW TABLES;

-- Descrever a tabela dependent
DESC dependent;
