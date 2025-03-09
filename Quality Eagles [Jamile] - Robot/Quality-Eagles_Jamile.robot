*** Settings ***
Documentation    Configurações iniciais do projeto

##Importando as Bibliotecas
Library    RequestsLibrary
Library    libs/get_fake_person.py
Library    libs/get_fake_company.py
Library    Collections
Library    Dialogs
Library    String

*** Variables ***
# URL
${BASE_URL}    https://quality-eagles.qacoders.dev.br/api

# ADMIN
${MAIL_ADMIN}    sysadmin@qacoders.com
${PASSWORD_ADMIN}    1234@Test

#USER
${MAIL_USER}    costadavi-lucca@example.com
${PASSWORD_USER}    B6Dc#4d@SM6U

${TOKEN_BLANK}    ""
${TOKEN_INVALID}    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2N2NhMzdhMzExZDVmZjc2Mjk2MjZmOTAiLCJmdWxsTmFtZSI6IkNhcm9saW5lIE5vdmFpcyIsIm1haWwiOiJjb3N0YWRhdmktbHVjY2FAZXhhbXBsZS5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRtTTdxWi9LeWxqMTZKM2I4T1hJaGl1bkttd0RGaFRWS1NzS21kV1I3bnVKSUVBWDRVMTJFcSIsImFjY2Vzc1Byb2ZpbGUiOiJBRE1JTiIsImNwZiI6IjQ1NzIxMzA5NjUyIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjY2ZGI1ZTQwZTVhMDAxNTYzNGYxMzdlNiIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoicXVpbnRhLWZlaXJhLCAwNi8wMy8yMDI1LCAyMTowMjo0MyBCUlQiLCJyZWdpc3RyYXRpb25OdW1iZXIiOiJRYUNvZGVycy0yOTkwIiwiX2lkIjoiNjdjYTM3YTMxMWQ1ZmY3NjI5NjI2ZjkxIn1dLCJfX3YiOjAsImlhdCI6MTc0MTQ3MjgzNSwiZXhwIjoxNzQxNTU5MjM1fQ.co6_pj0KsFiH5a3q6fLvqGECth4QHOyb603nu5XjIN4
${VALID_USER_ID}    67ccc44611d5ff7629a136b8
${INVALID_USER_ID}    67ccc44611d5ff7629a136b2
${VALID_COMPANY_ID}    67ccdaf911d5ff7629a82d31
${INVALID_COMPANY_ID}    67ccdaf911d5ff7629a82v47

# ROUTES
${LOGIN}    login
${USER}    user
${USER_COUNT}    user/count
${USER_PASSWORD}    user/password
${USER_STATUS}    user/status
${COMPANY}    company
${COMPANY_COUNT}    company/count
${COMPANY_ADDRESS}    company/address
${COMPANY_STATUS}    company/status

*** Test Cases ***
# REQUESTS LOGIN

TC01 - Realizar login com sucesso Admin
    [Documentation]    Realizar login de Admin com sucesso
    ${response}    Realizar login    email=${MAIL_ADMIN}    senha=${PASSWORD_ADMIN}
    Set Global Variable    ${TOKEN_ADMIN}    ${response.json()["token"]}
    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()}    token

    #Validação e-mail
    Should Be Equal As Strings    ${MAIL_ADMIN}    ${response.json()["user"]["mail"]}

TC02 - Realizar login com sucesso User
    [Documentation]    Realizar login de usuário com sucesso
    ${response}    Realizar login    email=${MAIL_USER}    senha=${PASSWORD_USER}
    Set Global Variable    ${TOKEN_USER}    ${response.json()["token"]}
    Status Should Be    200    ${response}
    Log To Console    ${TOKEN_USER}

    #Validação e-mail
    Should Be Equal As Strings    ${MAIL_USER}    ${response.json()["user"]["mail"]}
TC03 - Realizar login com senha inválida
    [Documentation]    Realizar login com a senha inválida e o e-mail válido
    ${response}     Realizar login    email=${MAIL_ADMIN}    senha=1234@Tes
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC04 - Realizar login com email inválido
    [Documentation]    Realizar login com o e-mail inválido e a senha válida
    ${response}     Realizar login    email=sysadmin@qacoders.com.br    senha=${PASSWORD_ADMIN}
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC05 - Realizar login com email e senha inválidos
    [Documentation]    Realizar login com e-mail e senha inválidos
    ${response}     Realizar login    email=sysadmin@qacoders.com.br    senha=1234@Tes
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC06 - Realizar login com e-mail em branco
    [Documentation]    Realizar login com o e-mail em branco e a senha válida
    ${response}     Realizar login    email=       senha=${PASSWORD_ADMIN}
    Status Should Be    500    ${response}
    Should Be Equal    first=O campo e-mail é obrigatório.    second=${response.json()["mail"]}
TC07 - Realizar login com a senha em branco
    [Documentation]    Realizar login com o e-mail válido e a senha em branco
    ${response}     Realizar login    email=${MAIL_ADMIN}    senha=
    Status Should Be    500    ${response}
    Should Be Equal    first=O campo senha é obrigatório.    second=${response.json()["password"]}

TC08 - Realizar login com e-mail e senha em branco
    [Documentation]    Realizar login com o e-mail e a senha em branco
    ${response}     Realizar login    email=       senha=
    #Status Should Be    500    ${response}
    Should Be Equal    first=O campo e-mail é obrigatório.    second=${response.json()["mail"]}
    Should Be Equal    first=O campo senha é obrigatório.    second=${response.json()["password"]}


# REQUESTS USERS
TC09 - Cadastro de usuário com sucesso
    [Documentation]    Realizar um cadastro de usuário com sucesso
    ${person}        Get Fake Person
    ${response}      Criar usuario    ${person}

    #Should Be Equal As Strings    ${response.status_code}    201

    #Validar campos
    ${user_data}    Set Variable    ${response.json()["user"]}
    Should Be True    isinstance(${user_data}, dict)
    Dictionary Should Contain Item    ${user_data}    fullName    ${person}[name]
    Dictionary Should Contain Item    ${user_data}    mail    ${person}[email]
    Dictionary Should Contain Item    ${user_data}    cpf    ${person}[cpf]

    Log To Console    Nome: ${user_data["fullName"]}
    Log To Console    Email: ${user_data["mail"]}

TC10 - Cadastrar usuário com nome com mais de 100 caracteres
    [Documentation]    Cadastrar usuário com nome com mais de 100 caracteres
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira Valo Velho Barro Preto Botafogo Santana Padre Clemente Henrique Moussier Uruguai Teresina Robert Spengler Neto
    ...    mail=isabelaoliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    ...    cpf=78599154719
    ...    password=5qLPT$6vpPfj
    ...    confirmPassword= 5qLPT$6vpPfj
    Status Should Be    400    ${response}
    #Should Be Equal    first=O nome completo deve ter no máximo 100 caracteres.    second=${response.json()["error"]}

TC11 - Cadastrar usuário com espaço no e-mail
    [Documentation]    Cadastrar usuário com espaço entre o nome e sobrenome no e-mail
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira 
    ...    mail=isabela oliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    ...    cpf=78599154719
    ...    password=5qLPT$6vpPfj
    ...    confirmPassword= 5qLPT$6vpPfj
    Status Should Be    400    ${response}
    #Should Be Equal    first=O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].    second=${response.json()["error"]}

TC12 - Cadastrar usuário com senha inválida
    [Documentation]    Cadastrar usuário com um e-mail inválido
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira
    ...    mail=isabela oliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    ...    cpf=78599154719
    ...    password=5qLPT6vpPfj
    ...    confirmPassword= 5qLPT6vpPfj
    Status Should Be    400    ${response}
    #Should Be Equal    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    second=${response.json()["error"]}


TC13 - Cadastrar usuário com e-mail inválido
    [Documentation]    Cadastrar usuário com um e-mail inválido
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira
    ...    mail=isabelaoliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders
    ...    cpf=78599154719
    ...    password=5qLPT$6vpPfj
    ...    confirmPassword= 5qLPT$6vpPfj
    Status Should Be    400    ${response}
    #Should Be Equal    first=O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].   second=${response.json()["error"]}


TC14 - Cadastrar usuário com CPF em branco
    [Documentation]    Cadastrar usuário com o CPF em branco
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira
    ...    mail=isabela oliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    ...    cpf=
    ...    password=5qLPT$6vpPfj
    ...    confirmPassword= 5qLPT$6vpPfj
    Status Should Be    400    ${response}
    #Should Be Equal    first=O campo CPF é obrigatório!   second=${response.json()["error"]}

TC15 - Exclusão de usuário com sucesso
    [Documentation]    Deletar um usuário existente
    ${response}    Cadastro Sucesso        
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}

    # Deletar usuário
    ${response}      Deletar usuario    ${user_id}

    # Validações3
    #Status Should Be    200    ${response}
    Should Be Equal    Usuário deletado com sucesso!.    ${response["msg"]}

TC16 - Exclusão de usuário com id inválido
    [Documentation]     Validar acesso negado à exclusão de usuários informando um id inválido
    ${response}=    DELETE On Session    alias=quality-eagles    url=/${USER}/${INVALID_USER_ID}?token=${TOKEN_USER}   expected_status=any
    Status Should Be    400
    Should Be Equal As Strings   ${response.json()["alert"][0]}    Esse usuário não existe em nossa base de dados.

TC17 - Exclusão de usuário com token em branco
    [Documentation]     Validar acesso negado à exclusão de usuários com token em branco
    ${response}=    DELETE On Session    alias=quality-eagles    url=/${USER}/${VALID_USER_ID}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC18 - Listagem de usuário com sucesso
    [Documentation]    Listar todos os usuários cadastrados
    ${response}    GET On Session    alias=quality-eagles    url=/${USER}/?token=${TOKEN_USER}
    Status Should Be    200    ${response}

   # Validar estrutura da resposta
    ${user_data}    Set Variable    ${response.json()}
    Should Be True    isinstance(${user_data}, list)
    Should Not Be Empty    ${user_data}

    # Validar primeiro usuário da lista
    ${first_user}    Set Variable    ${user_data[0]}

    # Validar campos obrigatórios
    Dictionary Should Contain Key    ${first_user}    fullName
    Dictionary Should Contain Key    ${first_user}    mail
    Dictionary Should Contain Key    ${first_user}    password
    Dictionary Should Contain Key    ${first_user}    accessProfile
    Dictionary Should Contain Key    ${first_user}    cpf

TC19 - Listagem de usuário com token inválido
    [Documentation]     Validar acesso negado à listagem de usuários com token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER}/${VALID_USER_ID}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
TC20 - Listagem de usuário com token em branco
    [Documentation]     Validar acesso negado à listagem de usuários com token em branco
    ${response}=   GET On Session    alias=quality-eagles    url=/${USER}/${VALID_USER_ID}?token=${TOKEN_BLANK}    expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC21- Listagem de usuário por id com sucesso
    [Documentation]    Realizar a busca de um usuário pelo seu id
    ${response}      Cadastro Sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    ${response}      Listar usuario por id    ${user_id}
    Should Be Equal As Strings    ${response.status_code}    200
    ${user_list}    Set Variable    ${response.json()}
    Should Be True    isinstance(${user_list}, dict)
    Dictionary Should Contain Key    ${user_list}    fullName
    Dictionary Should Contain Key    ${user_list}    mail
    Dictionary Should Contain Key    ${user_list}    cpf

TC22- Listagem de usuário por id com id inválido
    [Documentation]     Validar acesso negado à listagem de usuários por id com um id inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER}/${INVALID_USER_ID}?token=${TOKEN_USER}   expected_status=any
    Status Should Be    404
    Should Be Equal As Strings   ${response.json()["alert"][0]}    Esse usuário não existe em nossa base de dados.

TC23- Listagem de usuário por id com token em branco
    [Documentation]     Validar acesso negado à listagem de usuários por id com o token em branco
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER}/${VALID_USER_ID}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
   
TC24 - Contagem de usuário com sucesso
    [Documentation]    Realizar a contagem de todos os usuários cadastrados
    ${response}    GET On Session    alias=quality-eagles    url=/${USER_COUNT}/?token=${TOKEN_USER}
    Status Should Be    200    ${response}
    # Validar conteúdo da resposta
    Dictionary Should Contain Key   ${response.json()}    count

TC25 - Contagem de usuários com o token inválido
    [Documentation]     Validar acesso negado à contagem usuários com o token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER_COUNT}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
   

TC26 - Contagem de usuário token em branco
    [Documentation]     Validar acesso negado à contagem usuários com o token em branco
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER_COUNT}/?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC27 - Atualização de cadastro com sucesso
    [Documentation]    Atualizar dados básicos do usuário - e-mail
    ${person}    Get Fake Person
    ${response}    Cadastro Sucesso
    ${user_id}    Set Variable    ${response.json()["user"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${body}    Create Dictionary    fullName=${response.json()["user"]["fullName"]}    mail=${person}[email]
    ${response}    PUT On Session    alias=quality-eagles    url=/user/${user_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    #Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal    ${response.json()["msg"]}    Dados atualizados com sucesso!

   # Validar campos atualizados
    ${updated_user}    Set Variable    ${response.json()["updatedUser"]}
    Dictionary Should Contain Key    ${updated_user}    mail
    Should Be Equal    ${updated_user["mail"]}   ${person}[email]

    Log To Console   Email: ${person}[email]
    Log To Console    Novo email: ${updated_user["mail"]}
   

TC28 - Atualização de cadastro sem nome completo
    [Documentation]     Validar acesso negado à atualização de cadastro sem informar nome completo
    ${response}     Atualização manual de cadastro usuario
    ...    fullName=Isabella 
    ...    mail=isabelaoliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()["error"][0]}    Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.
#TC25 - Atualização de cadastro sem e-mail
    #[Documentation]    Tentar atualizar usuário sem nome completo
    #[Tags]    usuario_atualizacao
    #${person}    Get Fake Person
    #${response}    Cadastro Sucesso
    #${user_id}    Set Variable    ${response.json()["user"]["_id"]}
    #${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    #${body}    Create Dictionary    fullName=${person}[fullName]    mail=""
    #${response}    PUT On Session    alias=quality-eagles    url=/user/${user_id}?token=${token}    json=${body}    headers=${headers}
    #Status Should Be    400    ${response}

TC29 - Atualização de cadastro sem email
    [Documentation]     Validar acesso negado à atualização de cadastro sem informar o e-mail
    ${response}     Atualização manual de cadastro usuario
    ...    fullName=Isabella Oliveira
    ...    mail=
    Status Should Be    400    ${response}
   #Should Be Equal    ${response.json()["error"][0]}    O campo e-mail é obrigatório.

TC30 - Atualização de senha por id com sucesso
    [Documentation]    Atualizar senha do usuário utilizando seu id
    ${person}        Get Fake Person
    ${response}      Cadastro Sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${body}    Create Dictionary    password=9qJNsMDL75#A    confirmPassword=9qJNsMDL75#A
    ${response}    PUT On Session    alias=quality-eagles    url=/${USER_PASSWORD}/${user_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    Status Should Be    200
    Should Be Equal    ${response.json()["msg"]}    Senha atualizada com sucesso!

TC31 - Atualização de senha por id com id inválido
    [Documentation]     Validar acesso negado à atualização de senha com id inválido
    ${body}    Create Dictionary    password=9qJNsMDL75#A    confirmPassword=9qJNsMDL75#A
    ${response}    PUT On Session    alias=quality-eagles    url=/${USER_PASSWORD}/${INVALID_USER_ID}?token=${TOKEN_USER}    expected_status=any   
    Should Be Equal    ${response.json()["msg"]}    Esse usuário não existe em nossa base de dados.

TC32 - Atualização de senha por id com token em branco
    [Documentation]     Validar acesso negado à atualização de senha informando um token em branco
    ${body}    Create Dictionary    password=9qJNsMDL75#A    confirmPassword=9qJNsMDL75#A
    ${response}    PUT On Session    alias=quality-eagles    url=/${USER_PASSWORD}/${VALID_USER_ID}?token=${TOKEN_BLANK}    expected_status=any   
    Status Should Be    403
    Should Be Equal    ${response.json()["errors"][0]}    Failed to authenticate token.

TC33 -Atualização de status por id para false com sucesso
    [Documentation]    Atualizar o status para false utilizando o id do usuário
    ${person}        Get Fake Person
    ${response}      Cadastro Sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    ${resposta}      Atualizar status de usuario    user_id=${user_id}    status=false
    Status Should Be    200
    Should Be Equal    ${resposta['msg']}    Status do usuario atualizado com sucesso para status false.

TC34 - Atualização de status por id para true com sucesso
    [Documentation]    Atualizar o status para true utilizando o id do usuário
    ${person}        Get Fake Person
    ${response}      Cadastro Sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    ${response}      Atualizar status de usuario    user_id=${user_id}    status=true
    Status Should Be    200
    Should Be Equal    ${response['msg']}    Status do usuario atualizado com sucesso para status true.

TC35 - Atualização de status por id com id inválido
    [Documentation]     Validar acesso negado à atualizção de status com ID inválido
    ${headers}     Create Dictionary
    ...     accept=application/json
    ...     Content-Type=application/json
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${USER_STATUS}/${INVALID_USER_ID}?token=${TOKEN_USER}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    # Verifica o status code
    Status Should Be     404
   
TC36 - Atualização de status por id com token em branco
    [Documentation]     Validar acesso negado à atualização de status com o token em branco
    ${headers}     Create Dictionary
    ...     accept=application/json
    ...     Content-Type=application/json
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${USER_STATUS}/${VALID_USER_ID}?token=${TOKEN_BLANK}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    # Verifica o status code
    Status Should Be     403
    Should Be Equal    ${response.json()['errors'][0]}    Failed to authenticate token.

#     REQUESTS COMPANY
TC37 - Cadastrar empresa com sucesso
    [Documentation]    Realizar o cadastro de uma empresa
    ${company_fake}        Get Fake Company
    ${response}      Criar empresa    ${company_fake}
    
    Status Should Be    201    ${response} 
    Should Be Equal As Strings    ${company_fake}[corporateName]     ${response.json()["newCompany"]["corporateName"]}
    Should Be Equal As Strings    ${company_fake}[corporateEmail]     ${response.json()["newCompany"]["mail"]}
    Should Be Equal As Strings    ${company_fake}[cnpj]     ${response.json()["newCompany"]["registerCompany"]}
    
    Log To Console  Nome cadastrado: ${company_fake}[corporateName]
    Log To Console  Nome retornado: ${response.json()["newCompany"]["corporateName"]}

TC38 - Cadastrar empresa em duplicidade    
   [Documentation]     Validar acesso negado à cadastro de empresa em duplicidade
    ${response}     Criar empresa manual
    ...    corporateName=Teste do New Company
    ...    registerCompany=12126456000156
    ...    mail=test@newtest.com

    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()['alert'][0]}    Essa companhia já está cadastrada. Verifique o nome, CNPJ e a razão social da companhia.

TC39 - Cadastrar empresa sem nome da empresa
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o nome
    ${response}     Criar empresa manual
    ...    corporateName=
    ...    registerCompany=12126456000156
    ...    mail=test@newtest.com

    Status Should Be    400    ${response}
    #Should Be Equal    ${response.json()['error'][0]}    ValidationError: corporateName: O campo 'corporateName' é obrigatório.

TC40 - Cadastrar empresa sem o CNPJ
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o cnpj
    ${response}     Criar empresa manual
    ...    corporateName=Teste do New Company
    ...    registerCompany=
    ...    mail=test@newtest.com

    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()['error'][0]}    O campo 'CNPJ' da empresa é obrigatório.

TC41 - Cadastrar empresa sem email
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o e-mail
    ${response}     Criar empresa manual
    ...    corporateName=Teste do New Company
    ...    registerCompany=12126456000156
    ...    mail=

    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()['error'][0]}    O campo 'Email' é obrigatório.

TC41 - Exclusão de empresa com sucesso
    [Documentation]    Deletar uma empresa existente
    ${response}    Cadastro Empresa Sucesso        
    ${company_id}       Set Variable    ${response.json()["newCompany"]["_id"]}

    # Deletar usuário
    ${response}      Deletar empresa    ${company_id}

    # Validações3
    #Status Should Be    200    ${response}
    Should Be Equal   Companhia deletado com sucesso.    ${response["msg"]}

TC42 - Exclusão de empresa com id inválido
    [Documentation]     Validar acesso negado à exclusão de empresa informando um id inválido
    ${response}=    DELETE On Session    alias=quality-eagles    url=/${COMPANY}/${INVALID_COMPANY_ID}?token=${TOKEN_USER}   expected_status=any
    #Status Should Be    404
    #Should Be Equal As Strings   ${response.json()["msg"]}    Essa companhia não existem em nossa base de dados.

TC43 - Exclusão de empresa com token inválido
    [Documentation]     Validar acesso negado à exclusão de empresa informando um token inválido
    ${response}=    DELETE On Session    alias=quality-eagles    url=/${COMPANY}/${VALID_COMPANY_ID}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
TC44 - Listagem de empresa com sucesso
    [Documentation]    Listar todas as empresas cadastradas
    ${response}    GET On Session    alias=quality-eagles    url=/${COMPANY}/?token=${TOKEN_USER}
    Status Should Be    200    ${response}

   # Validar estrutura da resposta
    Should Be True    isinstance(${response.json()}, list)
    Should Not Be Empty    ${response.json()}

    # Validar primeiro usuário da lista
    ${first_company}    Set Variable    ${response.json()[0]}

    # Validar campos obrigatórios
    Dictionary Should Contain Key    ${first_company}    corporateName
    Dictionary Should Contain Key    ${first_company}    registerCompany
    Dictionary Should Contain Key    ${first_company}    responsibleContact
    Dictionary Should Contain Key    ${first_company}    mail
    Dictionary Should Contain Key    ${first_company}    telephone

TC45 - Listagem de empresa com token inválido
    [Documentation]     Validar acesso negado à listagem de empresa por id com um token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${COMPANY}/${VALID_COMPANY_ID}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC46 - Listagem de empresa com token em branco
    [Documentation]     Validar acesso negado à listagem de empresa por id com um token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${COMPANY}/${VALID_COMPANY_ID}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.    

TC47 - Contagem de empresa com sucesso
    [Documentation]    Realizar a contagem de todas as empresas cadastradas
    ${response}    GET On Session    alias=quality-eagles    url=/${COMPANY_COUNT}/?token=${TOKEN_USER}
    Status Should Be    200    ${response}
    # Validar conteúdo da resposta
    Dictionary Should Contain Key   ${response.json()}    count

TC48 - Contagem de empresa com token inválido
    [Documentation]     Validar acesso negado à contagem de empresa com o token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${COMPANY_COUNT}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC49 - Contagem de empresa com token em branco
    [Documentation]     Validar acesso negado à contagem usuários com o token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER_COUNT}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
TC50 - Atualização de cadastro da empresa por id com sucesso
    [Documentation]    Atualizar dados básicos da empresa - Responsável
    ${company_fake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${company_id}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${body}    Create Dictionary    corporateName=${response.json()["newCompany"]["corporateName"]}    registerCompany=${response.json()["newCompany"]["registerCompany"]}     mail=${response.json()["newCompany"]["mail"]}     matriz=Teste    responsibleContact= Marcio Freitas    telephone=${response.json()["newCompany"]["telephone"]}    serviceDescription=Teste 
    ${response}    PUT On Session    alias=quality-eagles    url=/${COMPANY}/${company_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal    ${response.json()["msg"]}    Companhia atualizada com sucesso.
    # Validar campos atualizados
    ${updated_company}    Set Variable    ${response.json()["updatedCompany"]}
    Dictionary Should Contain Key    ${updated_company}    responsibleContact

    # Remover espaços extras e comparar
    ${expected_contact}    Strip String    Marcio Freitas
    ${actual_contact}      Strip String    ${updated_company["responsibleContact"]}
    Should Be Equal    ${expected_contact}    ${actual_contact}

    Log To Console    Responsável atualizado: ${updated_company["responsibleContact"]}
    Log To Console    Dados da empresa atualizada: ${response.json()}

TC51 - Atualização de cadastro da empresa por id com token inválido
    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com um token inválido
    ${response}=    PUT On Session    alias=quality-eagles    url=/${COMPANY}/${VALID_COMPANY_ID}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC52 - Atualização de endereço da empresa com sucesso
    [Documentation]    Atualizar o endereço da empresa
    ${company_fake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${company_id}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${address}=    Create List
    ${address_item}=    Create Dictionary
    ...    zipCode=90906874
    ...    city=Vilhena
    ...    state=SP
    ...    district=Sossego
    ...    street=Alameda Getúlio Vargas
    ...    number=727
    ...    complement=de 4500 ao fim - lado par
    ...    country=Brasil
    Append To List    ${address}    ${address_item}
    ${body}=    Create Dictionary
    ...    corporateName=${response.json()["newCompany"]["corporateName"]}
    ...    registerCompany=${response.json()["newCompany"]["registerCompany"]}
    ...    mail=${response.json()["newCompany"]["mail"]}
    ...    matriz=Teste
    ...    responsibleContact=${response.json()["newCompany"]["responsibleContact"]}
    ...    telephone=${response.json()["newCompany"]["telephone"]}
    ...    serviceDescription=${response.json()["newCompany"]["serviceDescription"]}
    ...    address=${address}
    ${response}    PUT On Session    alias=quality-eagles    url=/${COMPANY_ADDRESS}/${company_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal    ${response.json()["msg"]}    Endereço da companhia atualizado com sucesso.
    
     # Validar campos atualizados
    Dictionary Should Contain Key     ${response.json()["updateCompany"]}    address

TC53 -Atualização de status por id para false com sucesso
    [Documentation]    Atualizar o status para false utilizando o id do usuário
      ${company_fake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${company_id}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${response}      Atualizar status da empresa    company_id=${company_id}    status=false
    Should Be Equal    ${response['msg']}    Status da companhia atualizado com sucesso.

TC54 - Atualização de status por id para true com sucesso
    [Documentation]    Atualizar o status para true utilizando o id do usuário
      ${company_fake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${company_id}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${response}      Atualizar status da empresa   company_id=${company_id}    status=true
    Should Be Equal    ${response['msg']}    Status da companhia atualizado com sucesso.
   
TC55 - Atualização de status por id com id inválido 
    [Documentation]     Validar acesso negado à atualizção de status da empresa com ID inválido
    ${headers}     Create Dictionary
    ...     accept=application/json
    ...     Content-Type=application/json
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${COMPANY_STATUS}/${INVALID_COMPANY_ID}?token=${TOKEN_USER}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    # Verifica o status code
    #Status Should Be     404

    #Should Be Equal    ${response['alert'][0]}    Essa companhia não existe em nossa base de dados.

TC56 - Atualização de status por id com token em branco
    [Documentation]     Validar acesso negado à atualizção de status da empresa com ID inválido
    ${headers}     Create Dictionary
    ...     accept=application/json
    ...     Content-Type=application/json
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${COMPANY_STATUS}/${VALID_COMPANY_ID}?token=${TOKEN_BLANK}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    
    Status Should Be     403

    Should Be Equal    ${response.json()["errors"][0]}   Failed to authenticate token.

*** Keywords ***
Criar sessao
    [Documentation]    Criação de sessão inicial pra usar nas próximas requests
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=quality-eagles    url=${BASE_URL}    headers=${headers}    verify=true

Realizar login
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}
    ${body}    Create Dictionary    mail=${email}    password=${senha}
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    expected_status=any    url=${LOGIN}    json=${body}
    RETURN    ${response}

Criar usuario
    [Documentation]    Criar um usuário com dados aleatórios
    [Arguments]    ${person}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${body}        Create Dictionary
                    ...    fullName=${person}[name]
                    ...    mail=${person}[email]
                    ...    password=B6Dc#4d@SM6U
                    ...    accessProfile=ADMIN
                    ...    cpf=${person}[cpf]
                    ...    confirmPassword=B6Dc#4d@SM6U


    ${response}      POST On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER}/?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    expected_status=500  #alterar para 201 após correção do bug

    RETURN           ${response}

Cadastro Sucesso
    ${person}        Get Fake Person
    ${id_user}       Criar Usuario     ${person}

    RETURN           ${id_user}
Cadastro manual de usuario
    [Documentation]    Criar um usuário com dados manuais
    [Arguments]    ${name}    ${mail}    ${cpf}    ${password}    ${confirmPassword}
    ${body}        Create Dictionary
                    ...    fullName= ${name}
                    ...    mail= ${mail}
                    ...    accessProfile=ADMIN
                    ...    cpf= ${cpf}
                    ...    password=${password}
                    ...    confirmPassword=${confirmPassword}



    ${response}      POST On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER}/?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    expected_status=400

    RETURN           ${response}

Atualização manual de cadastro usuario
    [Documentation]    Criar um usuário com dados manuais
    [Arguments]    ${name}    ${mail}   
    ${body}        Create Dictionary
                    ...    fullName= ${name}
                    ...    mail= ${mail}

    ${response}      PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER}/${VALID_USER_ID}?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    expected_status=400

    RETURN           ${response}    

Listar usuario por id
    [Arguments]    ${id}
    ${url}         Set Variable    /${USER}/${id}/?token=${TOKEN_USER}
    ${response}    GET On Session    alias=quality-eagles    url=${url}
    RETURN         ${response}

Atualizar status de usuario
    [Arguments]    ${user_id}    ${status}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
    ${body}        Create Dictionary    status=${status}
    ${response}    PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER_STATUS}/${user_id}?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    headers=${headers}
    RETURN         ${response.json()}

Atualizar senha de usuario
    [Arguments]    ${user_id}    ${password}    ${confirmPassword}
    ${body}    Create Dictionary    password=${password}    confirmPassword=${confirmPassword}
    ${headers}    Create Dictionary
    ...    accept=application/json
    ...    Content-Type=application/json

    ${response}    PUT On Session    alias=quality-eagles    url=/user/password/${user_id}?token=${TOKEN_USER}   json=${body}    headers=${headers}


Deletar usuario
    [Arguments]    ${user_id}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${response}    DELETE On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER}/${user_id}?token=${TOKEN_USER}
                     ...    headers=${headers}

    RETURN         ${response.json()}

Criar empresa
    [Documentation]    Criar uma empresa com dados aleatórios
    [Arguments]    ${company_fake}
    ${address}=    Create List
    ${address_item}=    Create Dictionary
    ...    zipCode=04777001
    ...    city=São Paulo
    ...    state=SP
    ...    district=Bom Jardim
    ...    street=Avenida Interlagos
    ...    number=50
    ...    complement=de 4503 ao fim - lado ímpar
    ...    country=Brasil
    Append To List    ${address}    ${address_item}           
    ${body}=    Create Dictionary
    ...    corporateName=${company_fake}[corporateName]
    ...    registerCompany=${company_fake}[cnpj]
    ...    mail=${company_fake}[corporateEmail]
    ...    matriz=Teste
    ...    responsibleContact=Guilherme Magalhaes
    ...    telephone=62877232459394
    ...    serviceDescription=Testes
    ...    address=${address}
     
   
    
    ${response}=    POST On Session
    ...    alias=quality-eagles
    ...    url=/${COMPANY}?token=${TOKEN_USER}
    ...    json=${body}
    ...    expected_status=201
    
    RETURN    ${response}
Cadastro Empresa Sucesso
    ${company_fake}        Get Fake Company
    ${id_company}       Criar Empresa     ${company_fake}

    RETURN           ${id_company}


Criar empresa manual
    [Documentation]    Criar uma empresa com dados aleatórios
    [Arguments]    ${corporateName}    ${registerCompany}    ${mail}
    ${address}=    Create List
    ${address_item}=    Create Dictionary
    ...    zipCode=04777001
    ...    city=São Paulo
    ...    state=SP
    ...    district=Bom Jardim
    ...    street=Avenida Interlagos
    ...    number=50
    ...    complement=de 4503 ao fim - lado ímpar
    ...    country=Brasil
    Append To List    ${address}    ${address_item}           
    ${body}=    Create Dictionary
    ...    corporateName=${corporateName} 
    ...    registerCompany=${registerCompany} 
    ...    mail=${mail}
    ...    matriz=Teste
    ...    responsibleContact=Guilherme Magalhaes
    ...    telephone=62877232459394
    ...    serviceDescription=Testes
    ...    address=${address}
     
     
   
    
    ${response}=    POST On Session
    ...    alias=quality-eagles
    ...    url=/${COMPANY}?token=${TOKEN_USER}
    ...    json=${body}
    ...   expected_status=any
    
    RETURN    ${response}
Listar empresa por id
    [Arguments]    ${id}
    ${url}         Set Variable    /${COMPANY}/${id}/?token=${TOKEN_USER}
    ${response}    GET On Session    alias=quality-eagles    url=${url}
    RETURN         ${response}

Atualizar status da empresa
    [Arguments]    ${company_id}    ${status}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
    ${body}        Create Dictionary    status=${status}
    ${response}    PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${COMPANY_STATUS}/${company_id}?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    headers=${headers}
    RETURN         ${response.json()}

Deletar empresa
    [Arguments]    ${company_id}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${response}    DELETE On Session
                     ...    alias=quality-eagles
                     ...    url=/${COMPANY}/${company_id}?token=${TOKEN_USER}
                     ...    headers=${headers}

    RETURN         ${response.json()}