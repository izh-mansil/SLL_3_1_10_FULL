﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ИдентификаторСессии;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сертификат = Параметры.Сертификат; // ДанныеФормыСтруктура - см. СервисКриптографииСлужебныйКлиент.ПолучитьМаркерБезопасности 
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СпособДоставкиПаролей = "phone";
	
	ПараметрыПроцедуры = Новый Структура("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	
	ДлительнаяОперация = СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьНастройкиПолученияВременныхПаролей", ПараметрыПроцедуры);
	
	ИспользоватьТокен = ЭлектроннаяПодписьВМоделиСервиса.ДолговременныйТокенИспользованиеВозможно();
	ПарольОтправляется = Истина;
	Элементы.ПолучитьВременныйПарольДругимСпособом.Видимость = Ложь;	
	Телефон = "...";
	
	Элементы.НастроитьПодтверждение.Заголовок = ПолучитьЗаголовокНастроек(ИспользоватьТокен, НСтр("ru = 'Изменить получателя'"));
	Элементы.НастроитьПодтверждение.РасширеннаяПодсказка.Заголовок = ?(ИспользоватьТокен, 
				НСтр("ru = 'Изменить настройки подтверждения операций с ключом'"), "");
	Элементы.ИндикаторДлительнойОперации.Картинка = ПолучитьКартинкуБиблиотеки("ДлительнаяОперация16");
	Элементы.ИндикаторДлительнойОперации2.Картинка = ПолучитьКартинкуБиблиотеки("ДлительнаяОперация16");

	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИдентификаторСессии = Неопределено;
	Оповещение = Новый ОписаниеОповещения("ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения", ЭтотОбъект);
	СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ДлительнаяОперация);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	Если Элементы.ГруппаПароль.Доступность Тогда 
		ПарольИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Пароль = СокрЛП(Текст);
	Если ЗначениеЗаполнено(Пароль) И СтрДлина(Пароль) = 6 Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьПароль");
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьПароль", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьОткрытую(ПараметрыФормы)
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьПароль");
	Если Открыта() Тогда 
		Закрыть(ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПарольПовторно(Команда)

	Пароль = Неопределено;
	Оповещение = Новый ОписаниеОповещения("ПолучитьВременныйПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПолучитьПарольНаСервере(Истина, ИдентификаторСессии));
		
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьПароль");
	ОчиститьСообщения();
	ТекстОшибки = "";
	Пароль = СокрЛП(Пароль);
	Если ЗначениеЗаполнено(Пароль) И СтрДлина(Пароль) = 6 Тогда
		Оповещение = Новый ОписаниеОповещения("ПодтвердитьПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПодтвердитьНаСервере(ИдентификаторСессии));
		УправлениеФормой(ЭтотОбъект);
	ИначеЕсли ЗначениеЗаполнено(Пароль) И СтрДлина(Пароль) <> 6 Тогда
		ТекстОшибки = НСтр("ru = 'Пароль должен состоять из 6 цифр'");
	Иначе
		ТекстОшибки = НСтр("ru = 'Пароль не указан'");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВременныйПарольДругимСпособом(Команда)
	
	Если СпособДоставкиПаролей = "phone" Тогда
		СпособДоставкиПаролей = "email";
	Иначе
		СпособДоставкиПаролей = "phone";
	КонецЕсли;
	
	ОтправитьПарольПовторно(Неопределено);
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодтверждение(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Сертификат", Сертификат);
	Если ИспользоватьТокен Тогда
		ПараметрыФормы.Вставить("Состояние", "ИзменениеСпособаПодтвержденияКриптооперации");
	Иначе
		ПараметрыФормы.Вставить("Состояние", "ИзменениеНастроекПолученияВременныхПаролей");
	КонецЕсли;	
	
	ЗакрытьОткрытую(ПараметрыФормы);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодтвердитьПарольПослеВыполнения(Результат, ВходящийКонтекст) Экспорт

	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		СохранитьМаркерыБезопасности(Результат.РезультатВыполнения);
		ЗакрытьОткрытую(Новый Структура("Состояние", "ПарольПринят"));
	Иначе
		ПарольПроверяется = Ложь;
		УправлениеФормой(ЭтотОбъект);
		
		ТекстИсключения = ОбработкаОшибок.ПодробноеПредставлениеОшибки(Результат.ИнформацияОбОшибке);
		Если СтрНайти(ТекстИсключения, "УказанНеверныйПароль") Тогда
			ТекстОшибки = НСтр("ru = 'Указан неверный пароль'");
		ИначеЕсли СтрНайти(ТекстИсключения, "ПревышенЛимитПопытокВводаПароля") Тогда
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Превышен лимит попыток ввода пароля'"))); 
		ИначеЕсли СтрНайти(ТекстИсключения, "СрокДействияПароляИстек") Тогда
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Срок действия пароля истек'")));
		Иначе 
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Выполнение операции временно невозможно'")));
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьМаркерыБезопасности(Знач МаркерыБезопасности)
	
	УстановитьПривилегированныйРежим(Истина);
	СервисКриптографииСлужебный.СохранитьМаркерыБезопасности(МаркерыБезопасности);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		Телефон          = Результат.РезультатВыполнения.Телефон;
		ЭлектроннаяПочта = Результат.РезультатВыполнения.ЭлектроннаяПочта;
		
		Получатель = Телефон;
		
		Оповещение = Новый ОписаниеОповещения("ПолучитьВременныйПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПолучитьПарольНаСервере());
	Иначе
		ДанныеОбОшибке = ПолучитьДеталиОшибки(Результат.ИнформацияОбОшибке);
		Оповещение = Новый ОписаниеОповещения("ПослеПоказаПредупреждения", ЭтотОбъект, ДанныеОбОшибке);
		ПоказатьПредупреждение(Оповещение, ДанныеОбОшибке.Информация);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПоказаПредупреждения(ВходящийКонтекст) Экспорт
	
	ЗакрытьОткрытую(ВходящийКонтекст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВременныйПарольПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		Таймер = Результат.РезультатВыполнения.ЗадержкаПередПовторнойОтправкой;
		ПарольОтправлен = Истина;
		ПарольОтправляется = Ложь;
		Если Результат.РезультатВыполнения.Свойство("ИдентификаторСессии") Тогда 
			ИдентификаторСессии = Результат.РезультатВыполнения.ИдентификаторСессии;
		КонецЕсли;
		ЗапуститьОбратныйОтсчет();
		УправлениеФормой(ЭтотОбъект);
		ПодключитьОбработчикОжидания("Подключаемый_АктивироватьПолеДляВводаПароля", 0.1, Истина);
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеПоказаПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьПароль()
	
	Подтвердить(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АктивироватьПолеДляВводаПароля()
	
	Пароль = Неопределено;
	Элементы.Пароль.ОбновитьТекстРедактирования();
	ТекущийЭлемент = Элементы.Пароль;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПарольНаСервере(Повторно = Ложь, ИдентификаторСессии = Неопределено)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	ПараметрыПроцедуры.Вставить("ПовторнаяОтправка", Повторно);
	ПараметрыПроцедуры.Вставить("Тип", СпособДоставкиПаролей);
	ПараметрыПроцедуры.Вставить("ИдентификаторСессии", ИдентификаторСессии);
	
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьВременныйПароль", ПараметрыПроцедуры);
	
КонецФункции

&НаКлиенте
Процедура ЗапуститьОбратныйОтсчет()
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОбратногоОтсчета()
	
	Таймер = Таймер - 1;
	Если Таймер >= 0 Тогда
		НадписьОбратногоОтсчета = СтрШаблон(НСтр("ru = 'Запросить пароль повторно можно будет через %1 сек.'"), Таймер);
		ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);		
	Иначе
		НадписьОбратногоОтсчета = "";
		ПарольОтправлен = Ложь;		
		НовыйЗаголовок	= НСтр("ru = 'Изменить адрес'");
		Элементы.ПолучитьВременныйПарольДругимСпособом.Видимость = ЗначениеЗаполнено(ЭлектроннаяПочта);
		Элементы.НастроитьПодтверждение.Заголовок = ПолучитьЗаголовокНастроек(ИспользоватьТокен, НовыйЗаголовок);
		
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДеталиОшибки(ДанныеОбОшибке)
	
	ТекстИсключения = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ДанныеОбОшибке);
	
	Результат = Новый Структура();
	Результат.Вставить("Состояние", "ПарольНеПринят");
	Результат.Вставить("Информация", НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.'"));
	Результат.Вставить("ОписаниеОшибки", ТекстИсключения);
	
	Если СтрНайти(ТекстИсключения, "InvalidCertificateIdError") Тогда
		Позиция = СтрНайти(ТекстИсключения, "Invalid certificate id");
		Если Позиция > 0 Тогда
			Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Не обнаружен сертификат в программе'") + ": " + Сред(ТекстИсключения, Позиция + 23, 40) + ".");
		Иначе	
			Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Не обнаружен сертификат в программе.'"));
		КонецЕсли;	
		Результат.Вставить("Информация", НСтр("ru = 'Указанный сертификат не обнаружен в программе.'"));
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЗаголовокНастроек(ТекущийРежим, НовыйЗаголовок)
	
	Результат = "Настройки";
	Если НЕ ТекущийРежим Тогда
		Результат = НовыйЗаголовок;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.НадписьОбратногоОтсчета.Видимость = Форма.ПарольОтправлен;	
	Элементы.ОтправитьПарольПовторно.Видимость = Не Форма.ПарольОтправлен И Не Форма.ПарольОтправляется;
	Элементы.ДекорацияОтступ.Видимость = Элементы.ПолучитьВременныйПарольДругимСпособом.Видимость;
	
	ТекстКоманды = НСтр("ru = 'Отправить пароль на %1'");
	Если Форма.СпособДоставкиПаролей = "phone" Тогда
		Если Форма.ПарольОтправляется Тогда
			Элементы.Пояснение.Заголовок = НСтр("ru = 'Выполняется отправка пароля в SMS-сообщении на номер'");
		Иначе
			Элементы.Пояснение.Заголовок = НСтр("ru = 'Пароль отправлен в SMS-сообщении на номер'");
		КонецЕсли;
		НовыйЗаголовок = НСтр("ru = 'Изменить номер'");
		Элементы.НастроитьПодтверждение.Заголовок = ПолучитьЗаголовокНастроек(Форма.ИспользоватьТокен, НовыйЗаголовок);
		Элементы.ПолучитьВременныйПарольДругимСпособом.Заголовок = СтрШаблон(ТекстКоманды, Форма.ЭлектроннаяПочта);
		Форма.Получатель = Форма.Телефон;
		Элементы.Пароль.ПодсказкаВвода = НСтр("ru = 'Введите пароль из SMS'");
	ИначеЕсли Форма.СпособДоставкиПаролей = "email" Тогда
		Если Форма.ПарольОтправляется Тогда
			Элементы.Пояснение.Заголовок = НСтр("ru = 'Выполняется отправка пароля в письме на адрес'");
		Иначе
			Элементы.Пояснение.Заголовок = НСтр("ru = 'Пароль отправлен в письме на адрес'");
		КонецЕсли;	
		НовыйЗаголовок = НСтр("ru = 'Изменить адрес'");
		Элементы.НастроитьПодтверждение.Заголовок = ПолучитьЗаголовокНастроек(Форма.ИспользоватьТокен, НовыйЗаголовок);
		Элементы.ПолучитьВременныйПарольДругимСпособом.Заголовок = СтрШаблон(ТекстКоманды, Форма.Телефон);
		Форма.Получатель = Форма.ЭлектроннаяПочта;
		Элементы.Пароль.ПодсказкаВвода = НСтр("ru = 'Введите пароль из письма'");
	КонецЕсли;

	Элементы.ИндикаторДлительнойОперации.Видимость = Форма.ПарольОтправляется
			И Элементы.ИндикаторДлительнойОперации.Картинка.Вид <> ВидКартинки.Пустая;
	Элементы.ИндикаторДлительнойОперации2.Видимость = Форма.ПарольПроверяется 
			И Элементы.ИндикаторДлительнойОперации2.Картинка.Вид <> ВидКартинки.Пустая;
	
	Элементы.ГруппаПароль.Доступность = Не Форма.ПарольОтправляется И Не Форма.ПарольПроверяется;		
	Элементы.ГруппаДополнительно.Доступность = Не Форма.ПарольОтправляется И Не Форма.ПарольПроверяется;
		
	Элементы.НадписьПроверкаПароля.Видимость = Форма.ПарольПроверяется;
	Элементы.ТекстОшибки.Видимость = Не Форма.ПарольПроверяется;
	
КонецПроцедуры

&НаСервере
Функция ПодтвердитьНаСервере(ИдентификаторСессии = Неопределено)
	
	ПарольПроверяется = Истина;

	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	ПараметрыПроцедуры.Вставить("ВременныйПароль", Пароль);
	ПараметрыПроцедуры.Вставить("ИдентификаторСессии", ИдентификаторСессии);
	
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьСеансовыйКлюч", ПараметрыПроцедуры);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКартинкуБиблиотеки(ИмяКартинки)
	
	Если Метаданные.ОбщиеКартинки.Найти(ИмяКартинки) <> Неопределено Тогда
		Результат = БиблиотекаКартинок[ИмяКартинки];
	Иначе
		Результат = Новый Картинка;
	КонецЕсли;	

	Возврат Результат;
	
КонецФункции

#КонецОбласти