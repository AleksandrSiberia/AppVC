
# AppVC

* AppVC * - проект демонстрирующий возможности продвинутого промышленного программирования на языке swift с использованием фреймворка
UIKit без использования сторибордов и с использованием последних нововведений языка.

### Используемые библиотеки
CoreData, Dispatch (GCD), Firebase, LocalAuthentication, Realm, KeychainSwift,  CoreGraphics, AVFoundation, SnapKit, UIKit, 
UserNotification, XCTest

### Архитектура 
MVC + MVVM + Coordinator + Assembly 

### Слои 
ApplicationLayer, ServiceLayer, Coordinators, PresentationLayer, Models


## Использованные преимущества 

### Большое внимание в приложении уделено безопасности:

1. Для локального хранения особо важных данных используется связка с шифрованием: **secRandomCopyBytes** на 64 байтах + **keychain** + 
**Realm with encryption**
2. Идентификация юзера происходит через **FirebaseAuth** с проверкой  на надежность пароля
3. Повторный вход в профиль после идентификации пользователя осуществляется с помощью биометрии **LocalAuthentication**

https://user-images.githubusercontent.com/103641721/221492992-f28d212d-3f54-4e83-8198-8ca1b2b6f338.mp4

5. Связка почта и пароль хранятся в зашифрованном **Realm**
6. Статус успешно пройденой идентификации хранится в **KeyCheine** 
7. Профиль пользователя, его данные и контент кэшируется в **CoreData** 
8. Данные юзера, его посты и комментарии, если пользователь выходит из профиля, сохраняются, при этом есть возможность войти
другим пользователям в свои профили, и тоже безопасно в закрытом виде от других кэшировать свои данные. 




### Взаимодействие с пользователем, визуализация. 

1. Приложение полностью локализировано на два языка: русский и английский


2. Также использована локализация (**LocalizableDict**) с изменением окончаний слов при изменении количества 
отображаемого контента. Пример: один лайк, два лайка.

https://user-images.githubusercontent.com/103641721/221500564-6e718496-e37c-4e28-9f09-4ac320745523.mp4


3. Приложение с помощью верстки на constrains и использованию безопасной зоны адаптировано к **iPad** и **iPhone** с разными экранами

https://user-images.githubusercontent.com/103641721/221498164-d7dfc731-5795-4d33-a1df-b2694d248311.mp4


5. Приложение полностью адаптировано к **светлой и темной теме**.

https://user-images.githubusercontent.com/103641721/221500040-a33c65eb-34c5-4a2e-98e9-d103210c499d.mp4


7. В приложении подключены **локальные уведомления**


8. Сделаны аудио и видео проигрыватели 

https://user-images.githubusercontent.com/103641721/221493526-b6b6d3ab-ddaa-4fae-8ca1-e59746da9abf.mp4


8. Сделана кастомная анимация 

https://user-images.githubusercontent.com/103641721/221508302-8c6217af-6693-40b0-b4d1-13c0102fcfdb.mp4


10. Действия пользователя отрабатываються локализоваными **алертами**, подсказками.


11. Визуально отображено состояние сущностей в реальном времени с помощью изменяющихся информационных рисунков: лайки, фавориты, 
данные юзера и тд

https://user-images.githubusercontent.com/103641721/221510499-4066e9a8-9849-456b-b4f6-9251a5a4e727.mp4


10. Сделана возможность управлять приложением с помощью двойных нажатий или свайпов

11. Реализовано изменение **constrains** при нажатии на кнопку комментариев, для показа и сокрытия комментариев, что позволило 
избежать необходимость пушить или презентовать новый контроллер  

https://user-images.githubusercontent.com/103641721/221502936-77622863-2fa8-4991-958d-da5e18d17b95.mp4


12. Везде настроено смещение вьюшек при появлении и исчезновении клавиатуры для удобства пользователя и доступа к кнопкам 
 
https://user-images.githubusercontent.com/103641721/221496376-0f6b94f5-3626-4421-b07a-73706fcf5a74.mp4


13. Новый пост кэшируется в CoreData и доступен во всех местах программы, и моментально обновляется при изменении

https://user-images.githubusercontent.com/103641721/221863013-1d6b1fce-4867-4799-b53a-2d355d6eb49c.mp4




14. Удобное редактирование поста

https://user-images.githubusercontent.com/103641721/221535552-4358caef-df3c-4afc-b795-2b3d8b62a091.mp4



### Масштабно задействованы преимущества CoreData 

1. Чтобы не загружать главный поток все операции с CoreData происходят в бэкграунд контексте. 
2. Созданы сущности связанные по цепочке от большого к меньшему с выстроенными отношениями с 
помощью **relationship**: профиль -> пост -> комментарий. Что позволяет им существовать как отдельные сущности со своими атрибутами и 
при этом взаимно конфигурировать друг с другом.
3. Сущности могут быть отредактированы при отсутствии интернета 
4. Для реактивного обновления  представлений при изменении сущностей, контекста,  использованы  **fetchedResultsController** и патерн 
проектирования **MVVM**.


### Для удобства поддержания кода использованы такие паттерны проектирования 

1. **Coordinator**. Позволяет при необходимости проще переводить отдельные части приложения с UIKit на SwiftUI за счет абстракции 
2. **Паттерн Delegate**. Позволил эффективно внедрять локальные зависимости и избегать сильных связей с помощью абстракций 
3. Только для небольших сервисов использовался паттерн **Одиночка**
5. Также использовался **фабричные методы** для удобной сборки контролеров и опять же помогает абстрагироваться 








