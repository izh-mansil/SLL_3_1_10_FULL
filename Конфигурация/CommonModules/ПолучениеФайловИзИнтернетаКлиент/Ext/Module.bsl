﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его по указанному пути на клиенте.
// Недоступно при работе в веб-клиенте. При работе в веб-клиенте необходимо пользоваться аналогичными
// серверными процедурами для скачивания файлов.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//   ПараметрыПолучения - см. ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла.
//   ЗаписыватьОшибку   - Булево - признак необходимости записи ошибки в журнал регистрации при получении файла.
//
// Возвращаемое значение:
//   Структура - сведения о полученном файле:
//      * Статус            - Булево - Истина, если файл получен успешно.
//      * Путь              - Строка - путь к файлу на клиенте, ключ используется только если статус Истина.
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь.
//      * Заголовки         - Соответствие - см. в синтакс-помощнике описание параметра Заголовки объекта HTTPОтвет.
//      * КодСостояния      - Число - добавляется при возникновении ошибки.
//                                    См. в синтакс-помощнике описание параметра КодСостояния объекта HTTPОтвет.
//
Функция СкачатьФайлНаКлиенте(Знач URL, Знач ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
#Если ВебКлиент Тогда
	ВызватьИсключение НСтр("ru = 'Скачивание файлов на клиент недоступно при работе в веб-клиенте.'");
#Иначе
	
	Результат = ПолучениеФайловИзИнтернетаСлужебныйВызовСервера.СкачатьФайл(URL, ПараметрыПолучения, ЗаписыватьОшибку);
	
	Если ПараметрыПолучения <> Неопределено
		И ПараметрыПолучения.ПутьДляСохранения <> Неопределено Тогда
		
		ПутьДляСохранения = ПараметрыПолучения.ПутьДляСохранения;
	Иначе
		ПутьДляСохранения = ПолучитьИмяВременногоФайла(); // АПК:441 Временный файл должен удаляться вызывающим кодом.
	КонецЕсли;
	
	Если Результат.Статус Тогда
		// АПК:1348-выкл ФайловаяСистемаКлиент.СохранитьФайл не используется для совместимости (синхронный вызов).
		ПолучитьФайл(Результат.Путь, ПутьДляСохранения, Ложь); 
		// АПК:1348-вкл
		Результат.Путь = ПутьДляСохранения;
	КонецЕсли;
	
	Возврат Результат;
	
#КонецЕсли
	
КонецФункции

// Открывает форму для ввода параметров прокси сервера.
//
// Параметры:
//    ПараметрыФормы - Структура - параметры открываемой формы.
//
Процедура ОткрытьФормуПараметровПроксиСервера(ПараметрыФормы = Неопределено) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
