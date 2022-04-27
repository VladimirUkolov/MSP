﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастроитьДинамическийСписок();
	УстановитьУсловноеОформление();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	Список.УсловноеОформление.Элементы.Очистить();
	Список.Группировка.Элементы.Очистить();
	
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВладелецФайла");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Параметры.ВладелецФайлов;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	ЭлементГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировки.Использование = Истина;
	ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("ВладелецФайла");
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДинамическийСписок()
	
	ВладелецФайлов = Параметры.ВладелецФайлов;
	
	ЗаголовокОшибки = НСтр("ru = 'Ошибка при настройке динамического списка присоединенных файлов.'");
	ОкончаниеОшибки = НСтр("ru = 'В этом случае настройка динамического списка невозможна.'");
	ИмяСправочникаХранилищаФайлов = РаботаСФайламиСлужебный.ИмяСправочникаХраненияФайлов(
		ВладелецФайлов, "", ЗаголовокОшибки, ОкончаниеОшибки);
	
	ТипСправочникаСФайлами = Тип("СправочникСсылка." + ИмяСправочникаХранилищаФайлов);
	МетаданныеСправочникаСФайлами = Метаданные.НайтиПоТипу(ТипСправочникаСФайлами);
	ВозможностьСоздаватьГруппыФайлов = МетаданныеСправочникаСФайлами.Иерархический;
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Файлы.Ссылка КАК Ссылка,
	|	Файлы.ПометкаУдаления КАК ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА Файлы.ПометкаУдаления = ИСТИНА
	|			ТОГДА ЕСТЬNULL(Файлы.ИндексКартинки, 2) + 1
	|		ИНАЧЕ ЕСТЬNULL(Файлы.ИндексКартинки, 2)
	|	КОНЕЦ КАК ИндексКартинки,
	|	Файлы.Наименование КАК Наименование,
	|	&ЭтоГруппа КАК ЭтоГруппа,
	|	Файлы.ВладелецФайла КАК ВладелецФайла
	|ИЗ
	|	&ИмяСправочника КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайлов
	|	И &ОтборГрупп";
	
	ПолноеИмяСправочника = "Справочник." + ИмяСправочникаХранилищаФайлов;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника", ПолноеИмяСправочника);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборГрупп", "Файлы.ЭтоГруппа");
	СвойстваСписка.ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ЭтоГруппа",
		?(ВозможностьСоздаватьГруппыФайлов, "Файлы.ЭтоГруппа", "ЛОЖЬ"));
		
	СвойстваСписка.ОсновнаяТаблица  = ПолноеИмяСправочника;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	Список.Параметры.УстановитьЗначениеПараметра("ВладелецФайлов", ВладелецФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ПереместитьФайлыВГруппу(Параметры.ПеремещаемыеФайлы, Значение);
	ОповеститьОбИзменении(ТипЗнч(Параметры.ПеремещаемыеФайлы[0]));
	Оповестить("Запись_Файл", Новый Структура, Параметры.ПеремещаемыеФайлы);
	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПереместитьФайлыВГруппу(Знач Файлы, Знач Группа)
	
	Если Файлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяТаблицы = Файлы[0].Метаданные().ПолноеИмя();
	
	Блокировка = Новый БлокировкаДанных;
	Для Каждого ФайлСсылка Из Файлы Цикл
		ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицы);
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ФайлСсылка);
	КонецЦикла;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка.Заблокировать();
		
		Для Каждого ФайлСсылка Из Файлы Цикл
			
			ЗаблокироватьДанныеДляРедактирования(ФайлСсылка);
			
			ФайлОбъект = ФайлСсылка.ПолучитьОбъект();
			ФайлОбъект.Родитель = Группа;
			ФайлОбъект.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьГруппу(Команда)
	Родитель = Неопределено;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Родитель = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Родитель",       Родитель);
	ПараметрыФормы.Вставить("ВладелецФайла",  ВладелецФайлов);
	ПараметрыФормы.Вставить("ЭтоНоваяГруппа", Истина);
	ПараметрыФормы.Вставить("ИмяСправочникаХранилищаФайлов", ИмяСправочникаХранилищаФайлов);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ГруппаФайлов", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
