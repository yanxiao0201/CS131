
import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSet implements State {
    private AtomicIntegerArray value;
    private byte maxval;

    GetNSet(byte[] v) { 
        value = new AtomicIntegerArray(v.length);
        byte i;
        for (i = 0; i < v.length; i++) {
            value.set(i, v[i]);
        }
        maxval = 127; 
    }

    GetNSet(byte[] v, byte m) { 
        value = new AtomicIntegerArray(v.length);
        byte j;
        for (j = 0; j < v.length; j++) {
            value.set(j, v[j]);
        }
        maxval = m; 
    }

    public int size() { return value.length(); }

    public byte[] current() { 
        byte[] result = new byte[value.length()];
        int k;
        for (k = 0; k < value.length(); k++) {
            result[k] = (byte) value.get(k);
        }
        return result;
    }

    public boolean swap(int i, int j) {
        if (value.get(i) <= 0 || value.get(j) >= maxval) {
            return false;
        }
        value.decrementAndGet(i);
        value.incrementAndGet(j);
        return true;
    }
}

