## 2.0.2

- Added `AsyncValueWrapper` public `const` constructor

## 2.0.1

- chore: update documentation issue

## 2.0.0

### Added

- Added dedicated identifier for `AsyncValueStatus`
- Added from json factory for `AsyncValueStatus`
- Added from json factory for `AsyncValueWrapper` using generic factory
- Added to json  `AsyncValueWrapper` using parsing method
- Added `HydratedAsyncValueCubit`

### Breaking change

- Added automatic serialisation / parsing in `HydratedAsyncValueCubit`
- Required `valueFromJson` and `valueToJson` implementation in `HydratedAsyncValueCubit`

## 1.1.0

### Added 

- `ErrorValueCubit` and `ErrorValueWrapper`

## 1.0.0

### Initial version. 

- `AsyncValueCubit` and `AsyncValueWrapper`