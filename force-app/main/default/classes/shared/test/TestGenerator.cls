public class TestGenerator {
    public static String randomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx + 1);
        }
        return randStr;
    }

    public static Integer randomInteger(Integer min, Integer max) {
        if (min >= max) {
            throw new IllegalArgumentException('Min must be less than max');
        }

        Integer range = max - min + 1;
        Double randomDouble = Math.random();
        Integer randomInteger = (Integer) (randomDouble * range) + min;
        return randomInteger;
    }

    public static Decimal randomDecimal(Integer min, Integer max) {
        if (min >= max) {
            throw new IllegalArgumentException('Min must be less than max');
        }

        Integer range = max - min + 1;
        Double randomDouble = Math.random();
        Decimal randomDecimal = (Decimal) (randomDouble * range) + min;
        return randomDecimal;
    }

    public static String randomEmail() {
        String username = randomString(8);
        String domain = randomString(5) + '.com';
        return username + '@' + domain;
    }
}
