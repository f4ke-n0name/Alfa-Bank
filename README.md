## Архитектура: VIPER

### Обоснование

Почему VIPER подходит:

- Банковское приложение сложное: много экранов, бизнес-логика (переводы, счета, лимиты), работа с абстракциями — VIPER хорошо справляется с такой сложностью
- Чёткое разделение слоёв делает код тестируемым
- Все зависимости через протоколы
- Router выделен отдельно, что важно для банка с его сложной навигацией (авторизация → главная → карты → детали транзакции)
---

## Навигационный флоу

```
┌───────────────────────────────────────────────────┐
│                    Старт приложения               │
│          Auth пробует восстановить сессию         │
└──────────────────────┬────────────────────────────┘
                       │
          ┌────────────▼────────────┐
          │         Auth            │  Вход: —
          │  phone + password       │  Выход: session (UserSession)
          └──────┬──────────┬───────┘
                 │          │
         успех   │          │ нет аккаунта
                 │          └─────────────────┐
    ┌────────────▼──┐                    ┌────▼────────────────┐
    │   CardList    │   успех → CardList │    Registration     │  Вход: —
    │               │◀────────────────── │  fullName/phone/pw  │  Выход: session
    └───────┬───────┘                    └────────┬────────────┘
            │                    
    (cardId, session)           
            │                   
    ┌───────▼───────┐           
    │  CardDetail   │ 
    │               │  Вход: cardId, session
    └───────┬───────┘  Выход: → cardId
            │
    (cardId, session)
            │
    ┌───────▼───────┐
    │ Transactions  │  Вход: cardId, session
    │               │  Выход: — (конечный экран)
    └───────────────┘
```

---


## Диаграмма зависимостей
```mermaid
graph TD
    subgraph CORE["⚙️ Core (Domain + Data)"]
        direction LR
        AR[(AuthRepository)]
        RR[(RegistrationRepository)]
        CR[(CardRepository)]
        TR[(TransactionRepository)]
    end

    subgraph AUTH["🔐 Auth"]
        AV[View] -->|ViewOutput| AP[Presenter]
        AP -->|ViewInput| AV
        AP --> AI[Interactor]
        AP --> ARout[Router]
        AI --> AR
    end

    subgraph REG["📋 Registration"]
        RV[View] --> RP[Presenter]
        RP --> RI[Interactor]
        RP --> RRout[Router]
        RI --> RR
    end

    subgraph CL["💳 CardList"]
        CLV[View] --> CLP[Presenter]
        CLP --> CLI[Interactor]
        CLP --> CLRout[Router]
        CLI --> CR
    end

    subgraph CD["🪪 CardDetail"]
        CDV[View] --> CDP[Presenter]
        CDP --> CDI[Interactor]
        CDP --> CDRout[Router]
        CDI --> CR
    end

    subgraph TX["📊 Transactions"]
        TXV[View] --> TXP[Presenter]
        TXP --> TXI[Interactor]
        TXP --> TXRout[Router]
        TXI --> CR
        TXI --> TR

        subgraph TABS["Табы (ViewState)"]
            HS[HistoryTabState]
            TS[TransferTabState]
        end
        TXP --> TABS
    end

    ARout -->|"openRegistration()"| REG
    ARout -->|"openCardList(session)"| CL
    RRout -->|"openCardList(session)"| CL
    CLRout -->|"openCardDetail(cardId, session)"| CD
    CDRout -->|"openTransactions(cardId, session)"| TX
    TXRout -->|"complete() → обновить баланс"| CD

    style AUTH fill:#dbeafe,stroke:#3b82f6
    style REG fill:#fce7f3,stroke:#ec4899
    style CL fill:#dcfce7,stroke:#22c55e
    style CD fill:#fef9c3,stroke:#eab308
    style TX fill:#ffe4e6,stroke:#f43f5e
    style TABS fill:#f3e8ff,stroke:#a855f7
    style CORE fill:#f1f5f9,stroke:#94a3b8
```

**Правило:** зависимости идут только вниз по слоям.  
`View → Presenter → Interactor → Repository`.  
Data-слой не знает о Presentation. Domain не знает об UIKit.
