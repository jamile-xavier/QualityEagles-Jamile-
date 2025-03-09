*** Settings ***
Documentation    Configurações iniciais do projeto

##Importando as Bibliotecas
Library    RequestsLibrary
Library    libs/get_fake_person.py

*** Variables ***
# URL
${BaseUrl}    https://quality-eagles.qacoders.dev.br/api/

# ADMIN
${MailAdmin}    sysadmin@qacoders.com
${PasswordAdmin}    1234@Test    

# ROUTES
${LOGIN}    /login
${USER}    /user
${USER_COUNT}    /user/count
${USER_PASSWORD}    /user/password
${USER_STATUS}    /user/status
${COMPANY}    /company
${COMPANY_COUNT}    /company/count
${COMPANY_PASSWORD}    /company/password
${COMPANY_STATUS}    /company/status

*** Test Cases ***
# REQUESTS LOGIN
  
TC01 - Realizar login com sucesso
    ${response}    Realizar login    email=${MailAdmin}    senha=${PasswordAdmin}
    Status Should Be    200    ${response}

TC02 - Realizar login com senha em branco
    ${response}    Realizar login    email=${MailAdmin}    senha=
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC03 - Realizar login com senha inválida
    ${response}     Realizar login    email=${MailAdmin}    senha=1234@Tes
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC04 - Realizar login com email inválido
  ${response}     Realizar login    email=sysadmin@qacoders.com.br    senha=${PasswordAdmin}
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC05 - Realizar login com email e senha inválidos
  ${response}     Realizar login    email=sysadmin@qacoders.com.br    senha=1234@Tes
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC06 - Realizar login com email em branco
  ${response}     Realizar login    email=    senha=${PasswordAdmin}
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC07 - Realizar login com email e senha em branco
  ${response}     Realizar login    email=   senha=
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

# REQUESTS USERS
TC08 - Realizar cadastro de usuário com sucesso
   ${response}    Cadastro sucesso   
   Status Should Be    201    $
   ...    {response}
   Log To Console    ${response}

#TC09 - Cadastrar usuário com nome com mais de 100 caracteres

#TC10 - Cadastrar usuário com nome espaço no e-mail

#TC11 - Cadastrar usuário com senha inválida
#TC12 - Cadastrar usuário com e-mail inválido
#TC13 - Cadastrar usuário com CPF em branco
#TC14 - Exclusão de usuário com sucesso
#TC15 - Exclusão de usuário com id inválido
#TC16 - Exclusão de usuário com token em branco
#TC17 - Listagem de usuário com sucesso
#TC18 - Listagem de usuário com token inválido
#TC19 - Listagem de usuário com token em branco
#TC20 - Contagem de usuário com sucesso
#TC21 - Contagem de usuário com token inválido
#TC22 - Contagem de usuário token em branco
#TC23 - Listagem de usuário por id com sucesso
#TC24 - Listagem de usuário por id com id inválido
#TC25 - Listagem de usuário por id com token em branco
#TC26 - Atualização de cadastro com sucesso
#TC27 - Atualização de cadastro sem nome completo
#TC28 - Atualização de cadastro sem e-mail
#TC29 - Atualização de senha por id com sucesso
#TC30 - Atualização de senha por id com id inválido
#TC31 - Atualização de senha por id csem token
#TC32 - Atualização de status por id para false com sucesso
#TC33 - Atualização de status por id para true com sucesso
#TC34 - Atualização de status por id com token em branco
# REQUESTS COMPANY
#TC35 - 
#TC36 - 
#TC37 -
#TC38 -
#TC39 -
#TC40 -

    
*** Keywords ***
Criar sessao
    [Documentation]    Criação de sessão inicial pra usar nas próximas requests
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=quality-eagles    url=${BaseUrl}    headers=${headers}    verify=true

Pegar token
    [Documentation]    Request utilizada para pegar token de admin
    ${body}    Create Dictionary    mail=${MailAdmin}    password=${PasswordAdmin}
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    url=${LOGIN}    json=${body}
    RETURN    ${response.json()["token"]}

Realizar login
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}    
    ${body}    Create Dictionary    mail=${email}    password=${senha}    
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    expected_status=any    url=${LOGIN}    json=${body}
    RETURN    ${response}

Criar usuario
    [Documentation]    Criar um usuário com dados aleatórios
    ${person}    Get Fake Person
    ${token}    Pegar token
    ${body}    Create Dictionary    fullName=${person}[name]    mail=${person}[email]    password=B6Dc#4d@SM6U    accessProfile=ADMIN    cpf=${person}[cpf]    confirmPassword=B6Dc#4d@SM6U
    ${response}    POST On Session    alias=quality-eagles    url=/${USER}/?token=${token}    json=${body}
    Status Should Be    201    ${response}
    RETURN    ${response.json()["user"]["_id"]}

Cadastro sucesso
    ${user_id}    Criar usuario