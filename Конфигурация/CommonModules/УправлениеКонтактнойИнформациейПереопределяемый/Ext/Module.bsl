﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Изменяет, добавляет, удаляет стандартные команды контактной информации, отображаемые в справочниках и документах,
// Вкл./Выкл. отображение иконок контактной информации слева от заголовка вида контактной информации,
// Изменяет положение кнопки Добавить дополнительное поле контактной информации,
// Изменяет ширину поля комментарий для полей контактной информации с типами Телефон, АдресЭлектроннойПочты, Skype,
// ВебСтраница, Факс
//
// Параметры:
//  Настройки - Структура:
//    * ОтображатьИконки - Булево
//    * ОписаниеКоманд - см. УправлениеКонтактнойИнформацией.ОписаниеКоманд
//    * ПоложениеКнопкиДобавить - ГоризонтальноеПоложениеЭлемента - допустимые значения: Лево, Право, Авто.
//                                                                  Лево - Безусловное положение слева.
//                                                                  Право - Безусловное положение слева.
//                                                                  Авто - Располагается справа, когда контактная
//                                                                         информация в виде поля. Располагается слева,
//                                                                         когда контактная информация в виде
//                                                                         гиперссылки, или ни одно поле контактной
//                                                                         информации не выведено в группе.
//    * ШиринаПоляКомментарий - Число - ширина поля комментарий для полей контактной информации с типами Телефон, АдресЭлектроннойПочты,
//                                      Skype, ВебСтраница, Факс. Данный параметр устанавливается только когда группа
//                                      контактной информации ограничена по ширине.
//
//  Пример:
//     Настройки.ОтображатьИконки = Истина;
//     Настройки.ШиринаПоляКомментарий = 10;
//     Настройки.ПоложениеКнопкиДобавить = ГоризонтальноеПоложениеЭлемента.Авто;
//
//     Адрес = Перечисления.ТипыКонтактнойИнформации.Адрес;
//     Настройки.ОписаниеКоманд[Адрес].ЗапланироватьВстречу.Заголовок  = НСтр("ru='Встреча'");
//     Настройки.ОписаниеКоманд[Адрес].ЗапланироватьВстречу.Подсказка  = НСтр("ru='Создать событие встречи'");
//     Настройки.ОписаниеКоманд[Адрес].ЗапланироватьВстречу.Картинка   = БиблиотекаКартинок.ЗапланированноеВзаимодействие;
//     Настройки.ОписаниеКоманд[Адрес].ЗапланироватьВстречу.Действие   = "_ДемоСтандартныеПодсистемыКлиент.ОткрытьФормуДокументаВстреча";
//    
//     _ДемоФактическийАдресОрганизации = УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоФактическийАдресОрганизации");
//      Настройки.ОписаниеКоманд[_ДемоФактическийАдресОрганизации] = 
//    	ОбщегоНазначения.СкопироватьРекурсивно(УправлениеКонтактнойИнформацией.КомандыТипаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес));
//      Настройки.ОписаниеКоманд[_ДемоФактическийАдресОрганизации].ЗапланироватьВстречу.Действие = ""; // Отключение действия команды для вида
//
//   Процедурам, указанных в свойстве Действие, передаются 2 параметра:
//       КонтактнаяИнформация - Структура:
//         * Представление - Строка
//         * Значение      - Строка
//         * Тип           - ПеречислениеСсылка.ТипыКонтактнойИнформации
//         * Вид           - СправочникСсылка.ВидыКонтактнойИнформации
//       ДополнительныеПараметры - Структура:        
//         * ВладелецКонтактнойИнформации - ОпределяемыйТип.ВладелецКонтактнойИнформации.
//         * Форма - ФормаКлиентскогоПриложения - форма объекта-владельца, предназначенная для вывода контактной информации.
//
//   Пример: 
//     Процедура ОткрытьФормуДокументаВстреча(КонтактнаяИнформация, ДополнительныеПараметры) Экспорт
//		  ЗначенияЗаполнения = Новый Структура;
//		  ЗначенияЗаполнения.Вставить("МестоПроведенияВстречи", КонтактнаяИнформация.Представление);
//		  Если ТипЗнч(ДополнительныеПараметры.ВладелецКонтактнойИнформации) = Тип("ДокументСсылка._ДемоЗаказПокупателя") Тогда
//		    	ЗначенияЗаполнения.Вставить("Предмет", ДополнительныеПараметры.ВладелецКонтактнойИнформации);
//		    	ЗначенияЗаполнения.Вставить("Контакт", "");
//		  Иначе
//		    	ЗначенияЗаполнения.Вставить("Контакт", ДополнительныеПараметры.ВладелецКонтактнойИнформации);
//		    	ЗначенияЗаполнения.Вставить("Предмет", "");
//		  КонецЕсли;
//
//		  ОткрытьФорму("Документ.Встреча.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения),
//			ДополнительныеПараметры.Форма);
//	   КонецПроцедуры
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт

	// _Демо начало примера

	Адрес = Перечисления.ТипыКонтактнойИнформации.Адрес;
	Настройки.ОписаниеКоманд[Адрес].ЗапланироватьВстречу.Заголовок  = НСтр("ru='Встреча'");
	Настройки.ОписаниеКоманд[Адрес].ЗапланироватьВстречу.Подсказка  = НСтр("ru='Создать событие встречи'");
	Настройки.ОписаниеКоманд[Адрес].ЗапланироватьВстречу.Картинка   = БиблиотекаКартинок.ГрупповоеОбсуждение;
	Настройки.ОписаниеКоманд[Адрес].ЗапланироватьВстречу.Действие   = "_ДемоСтандартныеПодсистемыКлиент.ОткрытьФормуДокументаВстреча";


    ДемоФактическийАдресОрганизации = УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоФактическийАдресОрганизации");
    Настройки.ОписаниеКоманд[ДемоФактическийАдресОрганизации] = 
    	ОбщегоНазначения.СкопироватьРекурсивно(УправлениеКонтактнойИнформацией.КомандыТипаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес));
    Настройки.ОписаниеКоманд[ДемоФактическийАдресОрганизации].ЗапланироватьВстречу.Действие = ""; // Отключение действия команды для вида
    
    ДемоЮридическийАдресОрганизации = УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоЮридическийАдресОрганизации");
    Настройки.ОписаниеКоманд[ДемоЮридическийАдресОрганизации] = 
    	ОбщегоНазначения.СкопироватьРекурсивно(УправлениеКонтактнойИнформацией.КомандыТипаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес));
    Настройки.ОписаниеКоманд[ДемоЮридическийАдресОрганизации].ЗапланироватьВстречу.Действие = ""; // Отключение действия команды для вида
    
    // _Демо конец примера
    
КонецПроцедуры

// Получает наименования видов контактной информации на разных языках.
//
// Параметры:
//  Наименования - Соответствие из КлючИЗначение - представление вида контактной информации на переданном языке:
//     * Ключ     - Строка - имя вида контактной информации. Например, "_ДемоАдресПартнера".
//     * Значение - Строка - наименование вида контактной информации для переданного кода языка.
//  КодЯзыка - Строка - код языка. Например, "en".
//
// Пример:
//  Наименования["_ДемоАдресПартнера"] = НСтр("ru='Адрес'; en='Address';", КодЯзыка);
//
Процедура ПриПолученииНаименованийВидовКонтактнойИнформации(Наименования, КодЯзыка) Экспорт
	
	// _Демо начало примера
	
	// Контактная информация справочника "Контактные лица партнеров"
	Наименования["_ДемоАдресКонтактногоЛица"] = НСтр("ru = 'Адрес контактного лица'", КодЯзыка);
	Наименования["_ДемоEmailКонтактногоЛица"] = НСтр("ru = 'Электронная почта контактного лица'", КодЯзыка);
	Наименования["Справочник_ДемоКонтактныеЛицаПартнеров"] = НСтр("ru = 'Контактная информация справочника ""Контактные лица партнеров""'", КодЯзыка);
	
	// _Демо конец примера
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов.Настройки
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
//
// Параметры:
//  КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//  Элементы   - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//  ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	// _Демо начало примера
	_ДемоОбновлениеИнформационнойБазыБСП.ПриНачальномЗаполненииВидовКонтактнойИнформации(КодыЯзыков, Элементы, ТабличныеЧасти);
	// _Демо конец примера
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
//
// Параметры:
//  Объект                  - СправочникОбъект.РолиИсполнителей - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
